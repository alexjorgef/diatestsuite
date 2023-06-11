module github.com/diadata-org/diadata/services/filtersBlockService

go 1.14

require (
	github.com/diadata-org/diadata v1.4.119
	github.com/segmentio/kafka-go v0.4.35
	github.com/sirupsen/logrus v1.8.1
)

replace (
	github.com/gogo/protobuf => github.com/regen-network/protobuf v1.3.3-alpha.regen.1
)