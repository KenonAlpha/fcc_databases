#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ The Beautiful Mare salon ~~"

MAIN_MENU() {
if [[ $1 ]]
then echo -e "\n$1"
fi

  SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id")
  echo -e "\nWhat would you like to do?"
  echo "$SERVICES" | while read ID BAR SERVICE
  do
  echo -e "$ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) SERVICE 1 ;;
  2) SERVICE 2 ;;
  3) SERVICE 3 ;;
  *) MAIN_MENU "Please enter a valid service id." ;;
  esac

}

SERVICE() {
  SERVICE_TO_DO=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  echo -e "\nPlease enter your phone number."
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
  echo -e "\nPlease write your name"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
  echo -e "\nPlease select time."
  read SERVICE_TIME

INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")

echo -e "I have put you down for a $SERVICE_TO_DO at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
