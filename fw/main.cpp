/*
  main.cpp - cleaned up and with all debug prints commented out
  Compile:
    g++ -std=c++17 -O2 -Wall -Wextra main.cpp -o main

  Debug notes:
    - All helpful debug printf(...) lines are present but commented out.
    - To enable any debug output, uncomment the specific printf(...) lines you want.
    - Debug prints are simple CSV-like lines intended to be easy to parse for Python plotting
      (e.g. "IR_DC,idx,value", "RED_RAW,idx,value", "PEAK,idx,value", "RATIO,idx,value", etc.).
    - No special debug macros or helper flush calls are required; simply uncomment the printf lines.
*/

#include <cstdio>
#include <cinttypes>
#include <cstdint>
#include <climits>
#include <cstdlib>
#include <cstring>

#define FreqS 25    // sampling frequency
#define SAMPLE_COUNT 100
#define BUFFER_SIZE SAMPLE_COUNT
#define MA4_SIZE 4 // DO NOT CHANGE
#define MAX_NUM_PEAKS 15

#ifndef min
#define min(a,b) ((a) < (b) ? (a) : (b))
#endif

static uint16_t pun_ir_buffer[SAMPLE_COUNT] = {
  33897,  34126,  34653,  35203,  35624,  35731,  35607,  35517,
  35600,  35796,  36011,  36208,  36393,  36520,  36665,  36853,
  36879,  36187,  35065,  34568,  34737,  35154,  35637,  35989,
  36118,  36066,  36019,  36111,  36285,  36500,  36663,  36797,
  36923,  37082,  37229,  37129,  36324,  35297,  34937,  35148,
  35496,  35867,  36141,  36250,  36176,  36147,  36236,  36386,
  36543,  36689,  36825,  36918,  37039,  37093,  36550,  35490,
  34891,  34969,  35263,  35575,  35877,  36050,  36062,  36017,
  36031,  36183,  36341,  36506,  36616,  36692,  36791,  36899,
  37032,  36839,  35916,  34972,  34748,  34992,  35290,  35598,
  35866,  35934,  35865,  35869,  35971,  36125,  36278,  36439,
  36552,  36661,  36781,  36929,  37055,  37174,  36976,  36034,
  35034,  34786,  35004,  35308,
};

static uint16_t pun_red_buffer[SAMPLE_COUNT] = {
  35431,  35505,  35713,  35957,  36130,  36176,  36132,  36087,
  36121,  36210,  36315,  36396,  36461,  36521,  36601,  36663,
  36678,  36399,  35909,  35677,  35739,  35900,  36107,  36262,
  36326,  36306,  36271,  36311,  36401,  36481,  36555,  36618,
  36678,  36722,  36791,  36767,  36423,  35984,  35809,  35902,
  36051,  36201,  36322,  36378,  36363,  36367,  36393,  36443,
  36524,  36600,  36651,  36693,  36768,  36759,  36549,  36104,
  35833,  35849,  35972,  36110,  36247,  36322,  36341,  36316,
  36339,  36392,  36457,  36533,  36581,  36614,  36671,  36716,
  36775,  36698,  36307,  35892,  35784,  35868,  36003,  36136,
  36251,  36292,  36278,  36274,  36319,  36385,  36454,  36521,
  36581,  36625,  36683,  36740,  36775,  36841,  36770,  36377,
  35930,  35813,  35899,  36008,
};

static int32_t an_x[BUFFER_SIZE];
static int32_t an_y[BUFFER_SIZE];

// SpO2 lookup table
static const uint8_t uch_spo2_table[184] = {
  95,95,95,96,96,96,97,97,97,97,97,98,98,98,98,98,99,99,99,99,
  99,99,99,99,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,
  100,100,100,100,99,99,99,99,99,99,99,99,98,98,98,98,98,98,97,97,
  97,97,96,96,96,96,95,95,95,94,94,94,93,93,93,92,92,92,91,91,
  90,90,89,89,89,88,88,87,87,86,86,85,85,84,84,83,82,82,81,81,
  80,80,79,78,78,77,76,76,75,74,74,73,72,72,71,70,69,69,68,67,
  66,66,65,64,63,62,62,61,60,59,58,57,56,56,55,54,53,52,51,50,
  49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,31,30,29,
  28,27,26,25,23,22,21,20,19,17,16,15,14,12,11,10,9,7,6,5,
  3,2,1
};

void maxim_heart_rate_and_oxygen_saturation(uint16_t *pun_ir_buffer, int32_t n_ir_buffer_length,
                                            uint16_t *pun_red_buffer, int32_t *pn_spo2, int8_t *pch_spo2_valid,
                                            int32_t *pn_heart_rate, int8_t *pch_hr_valid);

void maxim_find_peaks(int32_t *pn_locs, int32_t *n_npks, int32_t *pn_x, int32_t n_size,
                      int32_t n_min_height, int32_t n_min_distance, int32_t n_max_num);

void maxim_peaks_above_min_height(int32_t *pn_locs, int32_t *n_npks, int32_t *pn_x,
                                  int32_t n_size, int32_t n_min_height);

void maxim_remove_close_peaks(int32_t *pn_locs, int32_t *pn_npks, int32_t *pn_x,
                              int32_t n_min_distance);

void maxim_sort_ascend(int32_t *pn_x, int32_t n_size);

void maxim_sort_indices_descend(int32_t *pn_x, int32_t *pn_indx, int32_t n_size);

int main() {
    int32_t spo2;
    int8_t spo2_valid;
    int32_t heart_rate;
    int8_t hr_valid;

    maxim_heart_rate_and_oxygen_saturation(
        pun_ir_buffer,
        SAMPLE_COUNT,
        pun_red_buffer,
        &spo2,
        &spo2_valid,
        &heart_rate,
        &hr_valid
    );

    // Final output (always-on)
    // These lines are simple and useful to parse from Python
    //std::printf("FINAL,SPO2,%d\n", spo2);
    //std::printf("FINAL,SPO2_VALID,%d\n", spo2_valid);
    //std::printf("FINAL,HR,%d\n", heart_rate);
    //std::printf("FINAL,HR_VALID,%d\n", hr_valid);

    return 0;
}

void maxim_heart_rate_and_oxygen_saturation(
    uint16_t *pun_ir_buffer,
    int32_t n_ir_buffer_length,
    uint16_t *pun_red_buffer,
    int32_t *pn_spo2,
    int8_t *pch_spo2_valid,
    int32_t *pn_heart_rate,
    int8_t *pch_hr_valid
)
{
    uint32_t un_ir_mean = 0;
    int32_t k, n_i_ratio_count;
    int32_t i, n_exact_ir_valley_locs_count, n_middle_idx;
    int32_t n_th1 = 0, n_npks = 0;
    int32_t an_ir_valley_locs[MAX_NUM_PEAKS];
    int32_t n_peak_interval_sum = 0;

    int32_t n_y_ac = 0, n_x_ac = 0;
    int32_t n_spo2_calc = 0;
    int32_t n_y_dc_max = 0, n_x_dc_max = 0;
    int32_t n_y_dc_max_idx = 0;
    int32_t n_x_dc_max_idx = 0;
    int32_t an_ratio[5]; /* int32_t for sorting */
    int32_t n_ratio_average = 0;
    int32_t n_nume = 0, n_denom = 0;

    /* Safety: ensure buffer length does not exceed statically allocated arrays */
    if (n_ir_buffer_length > BUFFER_SIZE) {
        n_ir_buffer_length = BUFFER_SIZE;
    }
    if (n_ir_buffer_length <= 0) {
        *pn_spo2 = -999;
        *pch_spo2_valid = 0;
        *pn_heart_rate = -999;
        *pch_hr_valid = 0;
        return;
    }

    // plot_ir_raw.py
    //for (int k = 0; k < SAMPLE_COUNT; ++k) {std::printf("IR_RAW,%d,%u\n", k, static_cast<unsigned>(pun_ir_buffer[k]));}
    /* Step 1: Remove DC component from IR signal */
    un_ir_mean = 0;
    for (k = 0; k < n_ir_buffer_length; k++) un_ir_mean += pun_ir_buffer[k];
    un_ir_mean = un_ir_mean / static_cast<uint32_t>(n_ir_buffer_length);

    // Debug: print mean (uncomment if needed)
    //printf("IR_MEAN,%u\n", (unsigned)un_ir_mean);

    for (k = 0; k < n_ir_buffer_length; k++) {
        an_x[k] = -1 * (static_cast<int32_t>(pun_ir_buffer[k]) - static_cast<int32_t>(un_ir_mean));
        // Debug: per-sample DC-removed IR for plotting
        // plot_ir_ac.py
        //printf("IR_AC,%d,%d\n", k, an_x[k]);
    }

    /* Step 2: 4-point moving average
       Note: original code left the assignment commented. If you'd like the 4-pt MA,
       uncomment the assignment below. MA prints are provided for debugging.
    */
    for (k = 0; k < n_ir_buffer_length - MA4_SIZE; k++) {
        int32_t b0 = an_x[k], b1 = an_x[k+1], b2 = an_x[k+2], b3 = an_x[k+3];
        // To enable MA4 smoothing, uncomment the following line:
        an_x[k] = (b0 + b1 + b2 + b3) / 4;
        // Debug: show MA inputs and (potential) output
        //plot_ma4.py
        //printf("MA4,%d,%d,%d,%d,%d\n", k, b0, b1, b2, b3);
    }

    /* Step 3: adaptive threshold */
    n_th1 = 0;
    for (k = 0; k < n_ir_buffer_length; k++) n_th1 += an_x[k];
    n_th1 = n_th1 / n_ir_buffer_length;
    if (n_th1 < 30) n_th1 = 30;
    if (n_th1 > 60) n_th1 = 60;
    // Debug: threshold
    //printf("THRESHOLD,%d\n", n_th1);

    /* Step 4: detect valleys (peaks on inverted signal) */
    for (k = 0; k < MAX_NUM_PEAKS; k++) an_ir_valley_locs[k] = 0;
    maxim_find_peaks(an_ir_valley_locs, &n_npks, an_x, n_ir_buffer_length, n_th1, 4, MAX_NUM_PEAKS);

    // Debug: list peaks
    //for (k = 0; k < n_npks; ++k) printf("PEAK,idx,%d,val,%d\n", an_ir_valley_locs[k], (an_ir_valley_locs[k] >= 0 && an_ir_valley_locs[k] < n_ir_buffer_length) ? an_x[an_ir_valley_locs[k]] : 0);
    //printf("n_npks: %d, n_ir_buffer_length: %d\n", n_npks, n_ir_buffer_length);
    
    // plot_peaks.py
    //for (int i = 0; i < n_ir_buffer_length; i++) {printf("IR,%d,%d\n", i, an_x[i]);}
    //for (int k = 0; k < n_npks; k++) {int idx = an_ir_valley_locs[k];if (idx >= 0 && idx < n_ir_buffer_length) {printf("PEAK,%d\n", idx);}}
    
    /* Step 5: Heart rate from valley intervals */
    n_peak_interval_sum = 0;
    int32_t n_valid_intervals = 0;
    const int32_t MIN_INTERVAL = 8;

    if (n_npks >= 2) {
        for (k = 1; k < n_npks; k++) {
            int32_t interval = an_ir_valley_locs[k] - an_ir_valley_locs[k-1];
            //printf("HR_INTERVAL,%d,%d\n", k-1, interval); // Debug: intervals
            if (interval >= MIN_INTERVAL) {
                n_peak_interval_sum += interval;
                n_valid_intervals++;
            } else {
                // printf("HR_INTERVAL_REJECTED,%d\n", interval); // Debug: rejected short intervals
            }
        }

        if (n_valid_intervals > 0) {
            n_peak_interval_sum /= n_valid_intervals;
            *pn_heart_rate = static_cast<int32_t>((FreqS * 60) / n_peak_interval_sum);
            *pch_hr_valid = 1;
            //printf("HR_RESULT,avg_interval,%d,heart_rate,%d\n", n_peak_interval_sum, *pn_heart_rate);
        } else {
            *pn_heart_rate = -999;
            *pch_hr_valid = 0;
            //printf("HR_RESULT,INSUFFICIENT_VALID_INTERVALS\n");
        }
    } else {
        *pn_heart_rate = -999;
        *pch_hr_valid = 0;
        // printf("HR_RESULT,INSUFFICIENT_PEAKS,%d\n", n_npks);
    }

    /* Step 6: reload raw signals for SpO2 calculation */
    for (k = 0; k < n_ir_buffer_length; k++) {
        an_x[k] = static_cast<int32_t>(pun_ir_buffer[k]);
        an_y[k] = static_cast<int32_t>(pun_red_buffer[k]);
        // Debug: raw buffers (useful for plotting)
        //printf("IR_RAW,%d,%d\n", k, an_x[k]);
        //printf("RED_RAW,%d,%d\n", k, an_y[k]);
    }

    n_exact_ir_valley_locs_count = n_npks;
    //printf("n_exact_ir_valley_locs_count %d\n", n_exact_ir_valley_locs_count);

    /* Step 7: compute AC/DC ratios for SpO2 */
    n_ratio_average = 0;
    n_i_ratio_count = 0;
    for (k = 0; k < 5; k++) an_ratio[k] = 0;

    /* Validate valley indices */
    for (k = 0; k < n_exact_ir_valley_locs_count; k++) {
        if (an_ir_valley_locs[k] >= n_ir_buffer_length) {
            *pn_spo2 = -999;
            *pch_spo2_valid = 0;
            // printf("SPO2,INVALID_VALLEY_INDEX,%d\n", an_ir_valley_locs[k]);
            return;
        }
    }

    // Debug: number of valley pairs
    //printf("VALLEY_PAIRS,%d\n", (n_exact_ir_valley_locs_count ? n_exact_ir_valley_locs_count - 1 : 0));

    for (k = 0; k < n_exact_ir_valley_locs_count - 1; k++) {
        n_y_dc_max = INT32_MIN;
        n_x_dc_max = INT32_MIN;

        if (an_ir_valley_locs[k+1] - an_ir_valley_locs[k] > 3) {
            int32_t start = an_ir_valley_locs[k];
            int32_t end = an_ir_valley_locs[k+1];
            if (start < 0) start = 0;
            if (end > n_ir_buffer_length) end = n_ir_buffer_length;

            for (i = start; i < end; i++) {
                if (an_x[i] > n_x_dc_max) {
                    n_x_dc_max = an_x[i];
                    n_x_dc_max_idx = i;
                }
                if (an_y[i] > n_y_dc_max) {
                    n_y_dc_max = an_y[i];
                    n_y_dc_max_idx = i;
                }
            }

            // Debug: DC maxima
            // printf("VALLEY_RANGE,%d,%d,IR_DC_MAX_IDX,%d,IR_DC_MAX,%d,RED_DC_MAX_IDX,%d,RED_DC_MAX,%d\n",
            //        an_ir_valley_locs[k], an_ir_valley_locs[k+1], n_x_dc_max_idx, n_x_dc_max, n_y_dc_max_idx, n_y_dc_max);

            /* RED AC */
            n_y_ac = (an_y[an_ir_valley_locs[k+1]] - an_y[an_ir_valley_locs[k]]) *
                     (n_y_dc_max_idx - an_ir_valley_locs[k]);
            n_y_ac = an_y[an_ir_valley_locs[k]] + n_y_ac / (an_ir_valley_locs[k+1] - an_ir_valley_locs[k]);
            n_y_ac = an_y[n_y_dc_max_idx] - n_y_ac;

            /* IR AC */
            n_x_ac = (an_x[an_ir_valley_locs[k+1]] - an_x[an_ir_valley_locs[k]]) *
                     (n_x_dc_max_idx - an_ir_valley_locs[k]);
            n_x_ac = an_x[an_ir_valley_locs[k]] + n_x_ac / (an_ir_valley_locs[k+1] - an_ir_valley_locs[k]);
            n_x_ac = an_x[n_x_dc_max_idx] - n_x_ac;

            // Debug: AC values
            // printf("VALLEY_INTERVAL_AC,range,%d,%d,IR_AC,%d,RED_AC,%d\n", an_ir_valley_locs[k], an_ir_valley_locs[k+1], n_x_ac, n_y_ac);

            n_nume = (n_y_ac * n_x_dc_max) >> 7;
            n_denom = (n_x_ac * n_y_dc_max) >> 7;

            // Debug: intermediate ratio components
            // printf("RATIO_INTERMEDIATE,range,%d,%d,nume,%d,denom,%d\n",
            //        an_ir_valley_locs[k], an_ir_valley_locs[k+1], n_nume, n_denom);

            if (n_denom > 0 && n_i_ratio_count < 5 && n_nume != 0) {
                an_ratio[n_i_ratio_count++] = (n_nume * 100) / n_denom;
                // Debug: ratio added
                // printf("RATIO_ADDED,idx,%d,value,%d\n", n_i_ratio_count-1, an_ratio[n_i_ratio_count-1]);
            } else {
                // Debug: ratio skipped
                // printf("RATIO_SKIPPED,range,%d,%d,denom=%d,nume=%d\n",
                //        an_ir_valley_locs[k], an_ir_valley_locs[k+1], n_denom, n_nume);
            }
        } else {
            // Debug: valley interval too short
            // printf("VALLEY_INTERVAL_SKIPPED,range,%d,%d,reason,too_short\n", an_ir_valley_locs[k], an_ir_valley_locs[k+1]);
        }
    }

    // Debug: ratios collected
    // for (i = 0; i < n_i_ratio_count; ++i) printf("RATIOS,IDX_%d,%d\n", i, an_ratio[i]);

    maxim_sort_ascend(an_ratio, n_i_ratio_count);

    // Debug: sorted ratios
    // for (i = 0; i < n_i_ratio_count; ++i) printf("SORTED_RATIOS,IDX_%d,%d\n", i, an_ratio[i]);

    n_middle_idx = n_i_ratio_count / 2;
    if (n_middle_idx > 1) {
        n_ratio_average = (an_ratio[n_middle_idx - 1] + an_ratio[n_middle_idx]) / 2;
    } else if (n_i_ratio_count > 0) {
        n_ratio_average = an_ratio[n_middle_idx];
    } else {
        n_ratio_average = 0;
    }

    // Debug: final ratio used
    //printf("RATIO_FINAL,%d\n", n_ratio_average);

    if (n_ratio_average > 2 && n_ratio_average < 184) {
        n_spo2_calc = uch_spo2_table[n_ratio_average];
        *pn_spo2 = n_spo2_calc;
        *pch_spo2_valid = 1;
        // printf("SPO2_RESULT,%d\n", *pn_spo2);
    } else {
        *pn_spo2 = -999;
        *pch_spo2_valid = 0;
        // printf("SPO2_RESULT,INVALID_RATIO,%d\n", n_ratio_average);
    }
}

void maxim_find_peaks(
    int32_t *pn_locs,
    int32_t *n_npks,
    int32_t *pn_x,
    int32_t  n_size,
    int32_t  n_min_height,
    int32_t  n_min_distance,
    int32_t  n_max_num
)
{
    maxim_peaks_above_min_height(pn_locs, n_npks, pn_x, n_size, n_min_height);
    //printf("n_min_height,%d\n",n_min_height);

    // Debug: peaks above min height
    // for (int i = 0; i < *n_npks; ++i) {
    //     int idx = pn_locs[i];
    //     int32_t val = (idx >= 0 && idx < n_size) ? pn_x[idx] : 0;
    //     printf("PEAKS_ABOVE_MIN,IDX_%d,LOC_%d,VAL_%d\n", i, idx, val);
    // }

    maxim_remove_close_peaks(pn_locs, n_npks, pn_x, n_min_distance);
    //printf("n_min_distance,%d\n", n_min_distance);

    // Debug: final peaks
    // for (int i = 0; i < *n_npks; ++i) {
    //     int idx = pn_locs[i];
    //     int32_t val = (idx >= 0 && idx < n_size) ? pn_x[idx] : 0;
    //     printf("PEAKS_FINAL,IDX_%d,LOC_%d,VAL_%d\n", i, idx, val);
    // }

    *n_npks = min(*n_npks, n_max_num);
    //printf("n_npks: %d, n_max_num: %d\n",*n_npks, n_max_num);
}

void maxim_peaks_above_min_height(
    int32_t *pn_locs,
    int32_t *n_npks,
    int32_t *pn_x,
    int32_t  n_size,
    int32_t  n_min_height
)
{
    int32_t i = 1, n_width;
    *n_npks = 0;

    while (i < n_size - 1) {
        if (pn_x[i] > n_min_height && pn_x[i] > pn_x[i-1]) {
            n_width = 1;
            while (i + n_width < n_size && pn_x[i] == pn_x[i + n_width]) n_width++;

            if (i + n_width < n_size && pn_x[i] > pn_x[i + n_width] && (*n_npks) < MAX_NUM_PEAKS) {
                pn_locs[(*n_npks)++] = i;
                // Debug: stored peak
                // printf("PEAK_DETECT,PEAK_STORED,loc_idx,%d,val,%d,total_peaks,%d\n", i, pn_x[i], *n_npks);
                i += n_width + 1;
            } else {
                i += n_width;
            }
        } else {
            i++;
        }
    }
}

void maxim_remove_close_peaks(
    int32_t *pn_locs,
    int32_t *pn_npks,
    int32_t *pn_x,
    int32_t  n_min_distance
)
{
    maxim_sort_indices_descend(pn_x, pn_locs, *pn_npks);

    for (int32_t i = -1; i < *pn_npks; ++i) {
        int32_t n_old_npks = *pn_npks;
        *pn_npks = i + 1;
        for (int32_t j = i + 1; j < n_old_npks; ++j) {
            int32_t n_dist = pn_locs[j] - (i == -1 ? -1 : pn_locs[i]);
            if (n_dist > n_min_distance || n_dist < -n_min_distance) {
                pn_locs[(*pn_npks)++] = pn_locs[j];
            } else {
                // Debug: removed close peak
                // printf("REMOVE_CLOSE_PEAKS,REMOVE,loc=%d,dist=%d\n", pn_locs[j], n_dist);
            }
        }
    }

    maxim_sort_ascend(pn_locs, *pn_npks);

    // Debug: resulting locs
    // for (int i = 0; i < *pn_npks; ++i) printf("REMOVE_CLOSE_PEAKS,loc_after_filter,%d\n", pn_locs[i]);
}

void maxim_sort_ascend(int32_t *pn_x, int32_t n_size) {
    for (int32_t i = 1; i < n_size; ++i) {
        int32_t n_temp = pn_x[i];
        int32_t j;
        for (j = i; j > 0 && n_temp < pn_x[j - 1]; --j) pn_x[j] = pn_x[j - 1];
        pn_x[j] = n_temp;
    }
}

void maxim_sort_indices_descend(int32_t *pn_x, int32_t *pn_indx, int32_t n_size) {
    for (int32_t i = 1; i < n_size; ++i) {
        int32_t n_temp = pn_indx[i];
        int32_t j;
        for (j = i; j > 0 && pn_x[n_temp] > pn_x[pn_indx[j - 1]]; --j) pn_indx[j] = pn_indx[j - 1];
        pn_indx[j] = n_temp;
    }
}
