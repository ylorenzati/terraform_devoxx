package main

import (
	"fmt"
	"net/http"
	"os"
)

func handler(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()
	fmt.Fprintf(w, "Hi Devoxx 2017, I'm  %s!\n", hostname)
	fmt.Println("receive a request")
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
	fmt.Println("Listen on 8080")
}