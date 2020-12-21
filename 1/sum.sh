set -euo pipefail

for a in $(<input.txt); do
    for b in $(<input.txt); do
        for c in $(<input.txt); do
            if [ $a != $b -a $b != $c ]; then
                if [ $(($a+$b+$c)) -eq 2020 ]; then
                    echo $(($a*$b*$c))
                    echo $(($a+$b+$c))
                fi
            fi
        done
    done
done
