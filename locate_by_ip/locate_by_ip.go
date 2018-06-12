package main

import (
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

func callSvc(url string) ([]byte, error) {
	// call the API and return useful data.

	var returnedDataRaw []byte
	var err error

	client := &http.Client{
		Timeout: time.Second * 10,
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{},
		},
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Println(2)
		log.Println(err)
		return returnedDataRaw, err
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println(3)
		log.Println(err)
		return returnedDataRaw, err
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Println(4)
		log.Println(err)
		return returnedDataRaw, err
	}

	returnedDataRaw = body
	return returnedDataRaw, err

}

func parseJSONPayload(rawData []byte) (map[string]interface{}, error) {
	// just unmarshall the data into a map and return it please.
	var dataMap map[string]interface{}

	err := json.Unmarshal(rawData, &dataMap)
	if err != nil {
		return dataMap, err
	}

	return dataMap, err
}

func main() {
	debugOn := false

	urlBase := "https://freegeoip.app"
	urlPath := "/json/"
	url := urlBase + urlPath

	if debugOn {
		fmt.Printf("URL: %s\n", url)
	}

	returnedData, err := callSvc(url)
	if err != nil {
		panic(err)
	}

	dataMap, err := parseJSONPayload(returnedData)
	if err != nil {
		panic(err)
	}

	if debugOn {
		fmt.Println(string(returnedData))
	}

	fmt.Printf("Time: %v\n", time.Now())
	fmt.Printf("IP         : %s\n", dataMap["ip"])
	fmt.Printf("CountryCode: %s\n", dataMap["country_code"])
	fmt.Printf("CountryName: %s\n", dataMap["country_name"])
	//fmt.Printf("RegionCode : %s\n", dataMap["region_code"])
	fmt.Printf("RegionName : %s\n", dataMap["region_name"])
	fmt.Printf("City       : %s\n", dataMap["city"])
	fmt.Printf("ZipCode    : %s\n", dataMap["zip_code"])
	fmt.Printf("timeZone   : %s\n", dataMap["time_zone"])
	fmt.Printf("GeoLoc     : %f, %f\n", dataMap["latitude"], dataMap["longitude"])
	//fmt.Printf("MetroCode  : %f\n", dataMap["metro_code"])

}
