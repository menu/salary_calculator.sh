#!/usr/bin/env bash
#Define variables for text formating
Reset=$'\e[0m'           # Reset formatting
BBlack=$'\e[1;30m'       # Black color
BRed=$'\e[1;31m'         # Red color
BBlue=$'\e[1;34m'        # Blue color

#Define func for float operations
calc() { awk "BEGIN{ printf \"%.2f\n\", $* }"; }

#Define list of supported functions
currencies=("AED" "AFN" "ALL" "AMD" "ANG" "AOA" "ARS" "AUD" "AWG" "AZN" "BAM" "BBD" "BDT" "BGN" "BHD" "BIF" "BMD" "BND" "BOB" "BRL" "BSD" "BTC" "BTN" "BWP" "BYN" "BYR" "BZD" "CAD" "CDF" "CHF" "CLF" "CLP" "CNY" "COP" "CRC" "CUC" "CUP" "CVE" "CZK" "DJF" "DKK" "DOP" "DZD" "EGP" "ERN" "ETB" "EUR" "FJD" "FKP" "GBP" "GEL" "GGP" "GHS" "GIP" "GMD" "GNF" "GTQ" "GYD" "HKD" "HNL" "HRK" "HTG" "HUF" "IDR" "ILS" "IMP" "INR" "IQD" "IRR" "ISK" "JEP" "JMD" "JOD" "JPY" "KES" "KGS" "KHR" "KMF" "KPW" "KRW" "KWD" "KYD" "KZT" "LAK" "LBP" "LKR" "LRD" "LSL" "LTL" "LVL" "LYD" "MAD" "MDL" "MGA" "MKD" "MMK" "MNT" "MOP" "MRO" "MUR" "MVR" "MWK" "MXN" "MYR" "MZN" "NAD" "NGN" "NIO" "NOK" "NPR" "NZD" "OMR" "PAB" "PEN" "PGK" "PHP" "PKR" "PLN" "PYG" "QAR" "RON" "RSD" "RUB" "RWF" "SAR" "SBD" "SCR" "SDG" "SEK" "SGD" "SHP" "SLE" "SLL" "SOS" "SRD" "STD" "SVC" "SYP" "SZL" "THB" "TJS" "TMT" "TND" "TOP" "TRY" "TTD" "TWD" "TZS" "UAH" "UGX" "USD" "UYU" "UZS" "VEF" "VES" "VND" "VUV" "WST" "XAF" "XAG" "XAU" "XCD" "XDR" "XOF" "XPF" "YER" "ZAR" "ZMK" "ZMW" "ZWL")

#Import API token
source token.sh

#Salary validation regexp
re='^[0-9]+\.?[0-9]*$'

#Clean screen on start
clear

#BEGIN
read -p "Type your ${BBlue}salary currency${Reset} (ex. 'ILS', type '${BRed}list${Reset}' for list of currencies): " baseCurrency
while [[ ! "${currencies[*]}" =~ "$baseCurrency" ]] || [[ -z "$baseCurrency" ]]; do
    if [[ $baseCurrency == "list" ]]; then
        echo "---"
        echo "${BRed}Supported currencies${Reset}: ${currencies[*]}"
        echo "---"
    fi
    read -p "Type your ${BBlue}salary currency${Reset} (ex. 'ILS', type '${BRed}list${Reset}' for list of currencies): : " baseCurrency
done

read -p "Type your ${BBlue}salary amount${Reset}: " salary
while [[ ! $salary =~ $re ]]; do
    echo "Not a number! If you want enter float number, use '.' instead ',' "
    read -p "Type your ${BBlue}salary amount${Reset}: " salary
done

read -p "Type in which ${BBlue}currency convert${Reset} (ex. 'ILS', type '${BRed}list${Reset}' for list of currencies): " convertCurrency
while [[ ! "${currencies[*]}" =~ "$convertCurrency" ]] || [[ -z "$convertCurrency" ]]; do
    if [[ $convertCurrency == "list" ]]; then
        echo "---"
        echo "${BRed}Supported currencies${Reset}: ${currencies[*]}"
        echo "---"
    fi
    read -p "Type in which ${BBlue}currency convert${Reset} (ex. 'ILS', type '${BRed}list${Reset}' for list of currencies): " convertCurrency
done

if [[ "$baseCurrency" == "$convertCurrency" ]]
then
    echo "${BBlue}Your salary${Reset} is $salary $convertCurrency"
    exit
fi

exchangeRate=$(curl --silent --request GET "https://api.apilayer.com/currency_data/convert?to=$convertCurrency&from=$baseCurrency&amount=$salary" --header "apikey: $token" | grep -o "\"quote\":[^}]*" | grep -Eo "[0-9]+\.?[0-9]*" )

echo "1 $baseCurrency ${BBlue}equal${Reset} $exchangeRate $convertCurrency > Your salary in ${BBlue}$convertCurrency${Reset} is $(calc $salary*$exchangeRate)"