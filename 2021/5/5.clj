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
    (:y (:head l))
    (:y (:tail l))))

(defn vertical? [l]
  (= 
    (:x (:head l))
    (:x (:tail l))))


(defn diagonal? [l]
  (and
      (not (horizontal? l))
      (not (vertical? l))))

(defn cart [colls]
  (if (empty? colls)
    '(())
    (for [more (cart (rest colls))
          x (first colls)]
      (cons x more))))

(defn ints-between [a b]
  (if (< a b)
    (range a (inc b))
    (reverse (range b (inc a)))))

(defn coords [l]
  (let [x-list (ints-between (:x (:head l)) (:x (:tail l)))
        y-list (ints-between (:y (:head l)) (:y (:tail l)))]
  (cond
    (diagonal? l)
      (map list x-list y-list)
    :else
      (cart (list x-list y-list)))))


(let [lines (map
              parse
              (str/split 
                (slurp *in*) 
                #"\n"))
      points (apply concat (map coords lines))
      freq (frequencies points)]
  (println (count (filter #(> (val %1) 1) freq))))
  ;(println (map (fn [p] (filter (fn [l] (within? l p)) lines)) points)))
