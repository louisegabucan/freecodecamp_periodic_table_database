#!/bin/bash
PSQL="psql --tuples-only --username=postgres --dbname=periodic_table -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    WHERE_CLAUSE="WHERE atomic_number = $1"
  else
    WHERE_CLAUSE="WHERE symbol = '$1' OR name = '$1'"
  fi
  
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) $WHERE_CLAUSE")

  if [[ -z $ELEMENT_INFO ]]
  then
    echo I could not find that element in the database.
  else    
    echo $ELEMENT_INFO | while read ATOMIC_NUMBER BAR ELEMENT_NAME BAR ELEMENT_SYMBOL BAR ELEMENT_TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi