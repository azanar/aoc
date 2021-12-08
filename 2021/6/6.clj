(defn substep [arg]
  (let [val (first arg)
        count (second arg)]
    (if (= val 0)
      {6 count 8 count}
      {(dec val) count})))

(defn step [state]
  (apply merge-with + (map substep state)))

(defn steps [state n]
  (if (= n 0)
    state
    (steps (step state) (dec n))))


(let [start (frequencies (map #(Integer/parseInt %1) (clojure.string/split (clojure.string/trim (slurp *in*)) #",")))]
  (println (reduce + (map val (steps start 256)))))
