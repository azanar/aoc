(use '[clojure.string :only [join index-of]])

(defrecord seat [row column])

(defn str-index-of-chrs [s chrs]
  (apply min
         (filter
           number?
           (map 
             #(index-of s %)
             chrs))))

(defn str-split-at-chr [s chrs]
  (let [split-idx (str-index-of-chrs s chrs)]
    [(subs s 0 split-idx)
     (subs s split-idx)]))

(defn bsp-str-to-num [s lowerchr upperchr]
  (let [b (map 
            #(condp = %
               lowerchr "0"
               upperchr "1"
               %)
            s)
        bstr (str "2r" (join b))
        ]
    (read-string bstr)))

(defn seat-id [s]
  (+ (:column s) (* (:row s) 8)))

(let
  [seats (map seat-id
    (map 
      #(let [sp (str-split-at-chr % ["L","R"])]
         (seat. 
           (bsp-str-to-num (first sp) \F \B)
           (bsp-str-to-num (fnext sp) \L \R)))
         (clojure.string/split-lines (slurp "input.txt"))))
   sortedseats (sort seats)
   seatset (set seats)]
  (first 
    (drop-while 
      #(seatset %) 
      (range 
        (first sortedseats) 
        (last sortedseats)))))

