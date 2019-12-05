Group members' name and UFid:
Shubham Saoji - 26364957
Himavanth Boddu - 32451847

Steps to run code:
Unzip file
Traverse to project directory containing mix.exs
Run command 'mix run proj1.exs 100000 200000'

Number of actors is derived from logic.
If input range > 10000, No of actors = range/10000
else No of actors = 1

Based on observation that if input range is less than 10000, only single actor is used. In case input range is higher, the number of actors increases, each actor is assigned a sub-range of 10000. For very high input range, multiple actors are created facilitating better concurrency and better performance.



Result printed for above range:
180297 201 897
150300 300 501
124483 281 443
132430 323 410
117067 167 701
125460 246 510 204 615
110758 158 701
135837 351 387
156240 240 651
129775 179 725
118440 141 840
152608 251 608
136525 215 635
135828 231 588
156289 269 581
146952 156 942
193945 395 491
197725 275 719
125433 231 543
125500 251 500
192150 210 915
162976 176 926
105264 204 516
173250 231 750
175329 231 759
186624 216 864
123354 231 534
146137 317 461
126846 261 486
156915 165 951
116725 161 725
108135 135 801
125248 152 824
182650 281 650
174370 371 470
134725 317 425
105750 150 705
182250 225 810
190260 210 906
133245 315 423
172822 221 782
136948 146 938
193257 327 591
145314 351 414
152685 261 585
126027 201 627
131242 311 422
115672 152 761
180225 225 801
153436 356 431
120600 201 600
129640 140 926
104260 260 401
105210 210 501
140350 350 401
163944 396 414
102510 201 510


Code performance for range 100000 to 200000
real	0m1.676s
user	0m4.448s
sys	0m0.092s


ratio =  2.68


Code was tested for largest input range -> 1,00,000 to 2,00,00,000
ratio = 3.93


Kindly refer to CPU utilization screenshot. 100% utilization for all 4 cores







