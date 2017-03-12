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
	// Create a mux for routing incoming requests
	m := http.NewServeMux()

	// All URLs will be handled by this function
	m.HandleFunc("/", handler)

	// Create a server listening on port 8000
	s := &http.Server{
		Addr:    ":8000",
		Handler: m,
	}

	s.SetKeepAlivesEnabled(false)

	s.ListenAndServe()

	fmt.Println("Listen on 8080")
}