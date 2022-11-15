#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SALON_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

SALON_SERVICE_MENU() {

echo -e "\nServices Available:"


echo "$SALON_SERVICES" | while read SERVICE_ID BAR NAME
do
  echo "$SERVICE_ID) $NAME "
done

read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  1) BOOK_APPOINT;;
  2) BOOK_APPOINT;;
  3) BOOK_APPOINT;;
  4) BOOK_APPOINT;;
  *) SALON_SERVICE_MENU;;
esac

}

BOOK_APPOINT() {

  echo -e "\nPhone Number:"

  read CUSTOMER_PHONE
  
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo $CUSTOMER_NAME

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    #INSERT CUSTOMER NAME AND PHONE NUMBER
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time?"

  read SERVICE_TIME

  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."

}

SALON_SERVICE_MENU