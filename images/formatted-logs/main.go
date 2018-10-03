package main

import (
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"strconv"

	log "github.com/sirupsen/logrus"
)

var logger *log.Entry
var sequence = 0

func initLogger() *log.Entry {
	log.SetFormatter(&log.JSONFormatter{
		FieldMap: log.FieldMap{
			log.FieldKeyMsg: "message",
		},
	})

	log.SetOutput(os.Stdout)
	return log.WithFields(log.Fields{
		"hostname": os.Getenv("HOSTNAME"),
	})
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "OK")
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	var name string
	if r.Form["name"] != nil {
		name = r.Form["name"][0]
	} else {
		name = "stranger"
	}
	ip, port, _ := net.SplitHostPort(r.RemoteAddr)
	logger.WithFields(log.Fields{
		"remote_host": ip,
		"remote_port": port,
	}).Info(fmt.Sprintf("greeting request by %s", name))

	fmt.Fprintf(w, fmt.Sprintf("Hello, %s!", name))
}

func spitLogsHandler(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	if r.Form["logs"] != nil {
		if numOfLogs, err := strconv.Atoi(r.Form["logs"][0]); err != nil {
			fmt.Fprintf(w, fmt.Sprintf("[%s] is not integer :(", r.Form["logs"][0]))
		} else {
			if numOfLogs > 100 {
				fmt.Fprintf(w, "Calm down buddy! Some one has to pay for this ec2 instance!")
			} else {
				for i := sequence; i < sequence+numOfLogs; i++ {
					logger.WithField("sequence", i).Info("iterating in a loop")
				}
				sequence += numOfLogs
				fmt.Fprintf(w, fmt.Sprintf("Num of logs generated: %d", numOfLogs))
			}
		}
	} else {
		fmt.Fprintf(w, "Add query parameter 'logs' to your request.\nE.g. /generate?logs=10\nDon't overhaul the server, 100 logs per request is the cap.")
	}
}

func generateError(w http.ResponseWriter, r *http.Request) {
	logger.Error("Host unreachable: [database.svc]")
	fmt.Fprintf(w, "Error generated")
}

func main() {
	// logrus is compatible with standard golang's log API
	log.Info("Program initiated")

	// logger enriched with 'hostname' field, which will be
	// present in every log line
	logger = initLogger()

	logger.Info("Custom logger created")
	http.HandleFunc("/", healthHandler)
	http.HandleFunc("/hello", helloHandler)
	http.HandleFunc("/generate", spitLogsHandler)
	http.HandleFunc("/error", generateError)

	log.Fatal(http.ListenAndServe("0.0.0.0:8080", nil))
}
