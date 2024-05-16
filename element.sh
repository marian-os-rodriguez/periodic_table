#!/bin/bash



PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# Verificar si el primer argumento es un número
if [[ "$1" =~ ^[0-9]+$ ]]; 
then
    consulta=$($PSQL "select p.atomic_number,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius,e.symbol,e.name,t.type
                    FROM properties p JOIN elements e on (p.atomic_number=e.atomic_number)
                                      JOIN types t on (t.type_id=p.type_id)
                    WHERE p.atomic_number=$1")
    if [[ -z $consulta ]]; then
      echo "I could not find that element in the database."
    else
        IFS="|"
        read -r atomic_number atomic_mass melting_point boiling_point symbol name type <<< $consulta
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    fi                  
else
    if [ "${#1}" -eq 1 ] || [ "${#1}" -eq 2 ]; 
    then
      consulta=$($PSQL "select p.atomic_number,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius,e.symbol,e.name,t.type
                    FROM properties p JOIN elements e on (p.atomic_number=e.atomic_number)
                                      JOIN types t on (t.type_id=p.type_id)
                    WHERE e.symbol='$1'") 
      if [[ -z $consulta ]]; then
          echo "I could not find that element in the database."
      else
          IFS="|"
          read -r atomic_number atomic_mass melting_point boiling_point symbol name type <<< $consulta
          echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
      fi  
    else
        if [[ -n "$1" ]]; 
        then
          consulta=$($PSQL "select p.atomic_number,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius,e.symbol,e.name,t.type
                    FROM properties p JOIN elements e on (p.atomic_number=e.atomic_number)
                                      JOIN types t on (t.type_id=p.type_id)
                    WHERE e.name='$1'")
          if [[ -z $consulta ]]; then
            echo "I could not find that element in the database."
          else
            IFS="|"
            read -r atomic_number atomic_mass melting_point boiling_point symbol name type <<< $consulta
            echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
          fi   
        else
            echo "Please provide an element as an argument."
        fi
    fi
fi







