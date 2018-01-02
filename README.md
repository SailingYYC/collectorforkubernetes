# Monitoring Kubernetes

[Monitoring Kubernetes](https://www.outcoldsolutions.com/docs/monitoring-kubernetes/) enables you to start monitoring your Kubernetes cluster in few minutes.

**Features:**

- Log collection is based on native JSON logging driver.
- Tiny image, tiny binary. Very low memory, cpu and disk consumption.
- Enriches log lines with kubernetes metadata (container, image, pod, daemon sets, jobs, cron jobs, etc).
- Collect stats and events, allowing you to correlate logs with metrics.
- Collects process metrics.
- Delivering host specific logs allows us to monitor main components of the cluster.
- Uses HTTP Event Collector to ingest data in Splunk. Requires Splunk version 6.5 or above (talk to us if you need support for earlier version of Splunk).
- Support for multi line events.
- At least once delivery guarantee.
- Priority email support.

## Prerequisites Details

- Kubernetes 1.6+
- Splunk:
    - Version 6.5 or above
    - [Monitoring Kubernetes](https://splunkbase.splunk.com/app/3743/) installed
    - HTTP Event Collector Token, as per [Monitoring Kubernetes](https://www.outcoldsolutions.com/docs/monitoring-kubernetes/)

## QuickStart

```bash
$ helm install stable/collectorforkubernetes
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/collectorforkubernetes
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter                             | Description                                                  | Default                                           |
|---------------------------------------|--------------------------------------------------------------|---------------------------------------------------|
| `image.repository`                    | Repository for container image                               | outcoldsolutions/collectorforkubernetes           |
| `image.tag`                           | Container image tag                                          | 2.0.37.171023                                     |
| `image.pullPolicy`                    | Image pull policy                                            | IfNotPresent                                      |
| `resources.limits`                    | Server resource limits                                       | `limits: {cpu: 1, memory: 100Mi}`                 |
| `resources.requests`                  | Server resource requests                                     | `requests: {cpu: 100m, memory: 20Mi}`             |
| `rbac.create`                         | Bind collectorforkubernetes role                             | false                                             |
| `rbac.serviceAccountName`             | Existing ServiceAccount to use (ignored if rbac.create=true) | default                                           |
| `securityContext.privileged`          | Permit access to IO in /proc file system                     | true                                              |
| `updateStrategy`                      | Strategy for DaemonSet updates (requires Kubernetes 1.6+)    | RollingUpdate                                     |
| `tolerations`                         | Tolerations for the worker nodes                             | `{- operator: "Exists", effect: "NoSchedule"}`    |
| `general.dataPath`                    | Location for the database                                    | /data/                                            |
| `general.logLevel`                    | Log level (trace, debug, info, warn, error, fatal)           | info                                              |
| `general.httpServerBinding`           | Port binding for HTTP server for `/healthz` and `/metrics`   | :8080                                             |
| `general.telemetryEndpoint`           | Telemetry report endpoint, set it to empty disable           | https://license.outcold.solutions/telemetry/      |
| `general.licenseEndpoint`             | License check endpoint                                       | https://license.outcold.solutions/license/        |
| `general.license`                     | License code                                                 |                                                   |
| `general.hostname`                    | Hostname                                                     | *Docker daemon hostname is used by default*       |
| `general.kubernetes.nodeName`         | Connection to docker host                                    |                                                   |
| `output.splunk.url`                   | Splunk HTTP Event Collector url                              | **Required**                                      |
| `output.splunk.token`                 | Splunk HTTP Event Collector Token                            | **Required**                                      |
| `output.splunk.insecure`              | Allow invalid SSL server certificate                         | false                                             |
| `output.splunk.caPath`                | Path to CA cerificate                                        |                                                   |
| `output.splunk.caName`                | CA Name to verify                                            |                                                   |
| `output.splunk.frequency`             | Do not batch events for longer than                          | 5s                                                |
| `output.splunk.batchSize`             | Batch events to max sizebut not longer than set by frequency | 768K                                              |

The table below is only applicable if `input.system_stats.disabled` is `false`.

| Parameter                             | Description                         | Default                                           |
|---------------------------------------|-------------------------------------|---------------------------------------------------|
| `input.system_stats.pathCgroups`      | cgroups file system location        | /rootfs/sys/fs/cgroup                             |
| `input.system_stats.pathProc`         | proc file system location           | /rootfs/proc                                      |
| `input.system_stats.statsInterval`    | Frequency to collect cgroup stats   | 30s                                               |
| `input.system_stats.type`             | Override type                       | kubernetes_stats                                  |

The table below is only applicable if `input.proc_stats.disabled` is `false`.

| Parameter                             | Description                         | Default                                           |
|---------------------------------------|-------------------------------------|---------------------------------------------------|
| `input.proc_stats.pathProc`           | proc file system location           | /rootfs/proc                                      |
| `input.proc_stats.statsInterval`      | Frequency to collect cgroup stats   | 30s                                               |
| `input.proc_stats.type`               | Override type                       | kubernetes_stats                                  |

The table below is only applicable if `input.files.disabled` is `false`.

| Parameter                             | Description                         | Default                                           |
|---------------------------------------|-------------------------------------|---------------------------------------------------|
| `input.files.path`                    | Root location of docker files       | /rootfs/var/lib/docker/containers/                |
| `input.files.glob`                    | Glob matching pattern for log files | `*/*-json.log*`                                   |
| `input.files.pollingInterval`         | Files are read using polling schema, when reach the EOF how often to check if files got updated | 250ms |
| `input.files.walkingInterval`         | Frequency to scan for new files     | 5s                                                |
| `input.files.verboseFields`           | Include verbose fields in events (file offset) | false                                  |
| `input.files.type`                    | Override type                       | kubernetes_logs                                   |

The table below is only applicable if `input.files.syslog.disabled` is `false`.

| Parameter                              | Description                         | Default                                           |
|----------------------------------------|-------------------------------------|---------------------------------------------------|
| `input.files.syslog.path`              | Root location of docker files       | /rootfs/var/log/                                  |
| `input.files.syslog.match`             | Regex matching pattern              | `^syslog(.\d+)?$`                                 |
| `input.files.syslog.pollingInterval`   | Files are read using polling schema, when reach the EOF how often to check if files got updated | 250ms |
| `input.files.syslog.walkingInterval`   | Frequency to scan for new files     | 5s                                                |
| `input.files.syslog.verboseFields`     | Include verbose fields in events (file offset) | false                                  |
| `input.files.syslog.type`              | Override type                       | kubernetes_logs                                   |
| `input.files.syslog.extraction`        | Regex to extract fields             | `^(?P<timestamp>[A-Za-z]+\s\d+\s\d+:\d+:\d+)\s(?P<syslog_hostname>[^\s]+)\s(?P<syslog_component>[^:\[]+)(\[(?P<syslog_pid>\d+)\])?: (.+)$` |
| `input.files.syslog.timestampField`    | Timestamp field from extract fields | timestamp                                         |
| `input.files.syslog.timestampFormat`   | Format for timestamp, based on the reference time, defined to be `Mon Jan 2 15:04:05 -0700 MST 2006` | Jan 2 15:04:05 |
| `input.files.syslog.timestampLocation` | Timestamp location, if not defined by format | UTC                                      |

The table below is only applicable if `input.files.logs.disabled` is `false`.

| Parameter                             | Description                         | Default                                           |
|---------------------------------------|-------------------------------------|---------------------------------------------------|
| `input.files.logs.path`               | Root location of docker files       | /rootfs/var/log/                                  |
| `input.files.logs.match`              | Regex matching pattern              | `^[\w]+\.log(.\d+)?$`                             |
| `input.files.logs.pollingInterval`    | Files are read using polling schema, when reach the EOF how often to check if files got updated | 250ms |
| `input.files.logs.walkingInterval`    | Frequency to scan for new files     | 5s                                                |
| `input.files.logs.verboseFields`      | Include verbose fields in events (file offset) | false                                  |
| `input.files.logs.type`               | Override type                       | kubernetes_logs                                   |
| `input.files.logs.extraction`         | Regex to extract fields             |                                                   |
| `input.files.logs.timestampField`     | Timestamp field from extract fields |                                                   |
| `input.files.logs.timestampFormat`    | Format for timestamp, based on the reference time, defined to be `Mon Jan 2 15:04:05 -0700 MST 2006` |  |
| `input.files.logs.timestampLocation`  | Timestamp location, if not defined by format |                                          |

The table below is only applicable if `pipe.join.disabled` is `false`.

| Parameter                             | Description                                       | Default                                           |
|---------------------------------------|---------------------------------------------------|---------------------------------------------------|
| `pipe.join.maxInterval`               | Maximum interval of messages in pipeline          | 100ms                                             |
| `pipe.join.maxWait`                   | Maximum time to wait for the messages in pipeline | 1s                                                |
| `pipe.join.maxSize`                   | Maximum message size                              | 100K                                              |
| `pipe.join.patternRegex`              | Default pattern to indicate new message           | ^[^\s]                                            |

The table below is only applicable if `pipe.join.kube-apiserver.disabled` is `false`. This is a default join rule for Kubernetes' API server trace messages.

| Parameter                               | Description                                       | Default                                           |
|-----------------------------------------|---------------------------------------------------|---------------------------------------------------|
| `pipe.join.kube-apiserver.matchRegex`   | Regex to determine logs to apply to               | `{kubernetes_container_image: ^gcr.io/google_containers/kube-apiserver-.*$, docker_stream: stderr}` |
| `pipe.join.kube-apiserver.patternRegex` | Regex to determine a new event                    | ^[IWEF]\d{4}\s\d{2}:\d{2}:\d{2}.\d{6}\s           |

The table below shows how to define a custom join rule for a container called `my_app`, where all log file events start from `[<digits>`. For more information, see [Join Rules](https://www.outcoldsolutions.com/docs/collectorforkubernetes/#join-rules).

| Parameter                             | Description                                       | Default                                                       |
|---------------------------------------|---------------------------------------------------|---------------------------------------------------------------|
| `pipe.join.my_app.matchRegex`         | Regex to determine logs to apply to               | `{kubernetes_container_image: my_app, docker_stream: stdout}` |
| `pipe.join.my_app.patternRegex`       | Regex to determine a new event                    | ^\[\d+                                                        |
