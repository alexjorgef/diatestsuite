package main

import (
	"flag"
	"fmt"
	"sync"
	"time"

	"github.com/diadata-org/diadata/pkg/dia/helpers/configCollectors"
	scrapers "github.com/diadata-org/diadata/pkg/dia/scraper/exchange-scrapers"
	"github.com/diadata-org/diadata/pkg/utils"

	"github.com/diadata-org/diadata/pkg/dia"
	"github.com/diadata-org/diadata/pkg/dia/helpers/kafkaHelper"
	models "github.com/diadata-org/diadata/pkg/model"
	"github.com/sirupsen/logrus"
)

func init() {

}

func main() {
	log = logrus.New()
	logrus.SetLevel(logrus.WarnLevel)
	flag.Parse()
}