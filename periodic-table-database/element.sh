PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN() {
    if [[ -z $1 ]]
    then
    echo Please provide an element as an argument.

    elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
    then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    if [[ -z $ATOMIC_NUMBER ]]
    then
    echo "I could not find that element in the database."
    else
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=(SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER)")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTS celsius and a boiling point of $BOILS celsius."
    fi

    elif [[ $1 =~ ^[A-Z][a-z]*$ ]]
    then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    if [[ -z $ATOMIC_NUMBER ]]
    then
    echo "I could not find that element in the database."
    else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=(SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER)")
    echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MELTS celsius and a boiling point of $BOILS celsius."
    fi

    elif [[ $1 =~ ^[0-9]* ]]
    then
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    if [[ -z $NAME ]]
    then
    echo "I could not find that element in the database."
    else
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
    MELTS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
    BOILS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=(SELECT type_id FROM properties WHERE atomic_number=$1)")
    echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTS celsius and a boiling point of $BOILS celsius."
    fi


    fi
}

MAIN "$1"
