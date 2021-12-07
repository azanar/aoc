(require '[clojure.string :as str])

(defrecord Point [x y])
(defrecord Line [head tail])

(defn parse [l]
  (let [m (re-matcher #"(\d+),(\d+) -> (\d+),(\d+)" l)]
    (if (.matches m)
      (Line. 
        (Point. (Integer/parseInt (.group m 1)) (Integer/parseInt (.group m 2))) 
        (Point. (Integer/parseInt (.group m 3)) (Integer/parseInt (.group m 4)))))))

(defn horizontal? [l]
  (= 
    (:x (:head l))
    (:x (:tail l))))

(defn vertical? [l]
  (= 
    (:y (:head l))
    (:y (:tail l))))


(defn diagonal? [l]
  (and
      (not (horizontal? l))
      (not (vertical? l))))



(defn within? [l p]
  (let [y-min (min (:y (:head l)) (:y (:tail l)))
        y-max (max (:y (:head l)) (:y (:tail l)))
        x-min (min (:x (:head l)) (:x (:tail l)))
        x-max (max (:x (:head l)) (:x (:tail l)))]

  (cond
    (vertical? l) (and 
                    (= (:x p) (:x (:head l)))
                    (<= y-min (:y p) y-max))
    (horizontal? l) (and 
                    (= (:y p) (:y (:head l)))
                    (<= x-min (:x p) x-max))

    :else false)))

(let [lines (filter 
           #(not (diagonal? %1))
             (map
              parse
              (str/split 
                (slurp "input.txt") 
                #"\n")))]
  (map (count (filter (within? line point) (range min (inc max))
  (println (apply min (concat 
                  (map #(:x (:head %1)) lines) 
                  (map #(:x (:tail %1)) lines))))
  (println (apply max (concat 
                  (map #(:x (:head %1)) lines) 
                  (map #(:x (:tail %1)) lines))))
  (println (apply min (concat 
                  (map #(:y (:head %1)) lines) 
                  (map #(:y (:tail %1)) lines))))
  (println (apply max (concat 
                  (map #(:y (:head %1)) lines) 
                  (map #(:y (:tail %1)) lines)))))
