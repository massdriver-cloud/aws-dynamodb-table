## AWS DynamoDB

Amazon DynamoDB is a fully managed NoSQL database service that provides fast and predictable performance with seamless scalability. DynamoDB allows users to offload the administrative burdens of operating and scaling a distributed database, so they don't have to worry about hardware provisioning, setup and configuration, replication, software patching, or cluster scaling.

### Design Decisions

1. **Provisioned and On-Demand Capacity Modes**:
    - This setup allows specifying provisioned read and write capacity for predictable and consistent performance.
    - Alarms are configured to notify when the usage exceeds 80% of the provisioned capacity, urging you to scale up to prevent throttling.

2. **IAM Policies**:
    - Separate IAM policies for read, write, and read/write operations, ensuring fine-grained access control.
  
3. **DynamoDB Streams** (Optional):
    - Streams can be enabled for table changes, with specific IAM policies for stream read operations.

4. **Global Secondary Indexes (GSI)**:
    - Supports the addition of GSIs to enhance query flexibility.
    - Alarms for GSI read and write capacity to ensure that indexes are scaled adequately with usage.

### Runbook

#### High Read Capacity Usage

When the read capacity usage of a DynamoDB table exceeds the threshold.

Check the ConsumedReadCapacityUnits metrics to understand high-usage patterns.

```sh
aws cloudwatch get-metric-statistics --namespace AWS/DynamoDB --metric-name ConsumedReadCapacityUnits \
--dimensions Name=TableName,Value=<YourDynamoDBTableName> \
--start-time 2023-01-01T00:00:00Z --end-time 2023-01-02T00:00:00Z --period 300 --statistics Average
```

Ensure that the read capacity is scaled to accommodate peak loads.

#### High Write Capacity Usage

When the write capacity usage of a DynamoDB table exceeds the threshold.

Check the ConsumedWriteCapacityUnits metrics to understand high-usage patterns.

```sh
aws cloudwatch get-metric-statistics --namespace AWS/DynamoDB --metric-name ConsumedWriteCapacityUnits \
--dimensions Name=TableName,Value=<YourDynamoDBTableName> \
--start-time 2023-01-01T00:00:00Z --end-time 2023-01-02T00:00:00Z --period 300 --statistics Average
```

Ensure that the write capacity is scaled to accommodate peak loads.

#### Stream Issues

If you are having issues with DynamoDB streams not functioning as expected.

Check the stream settings and its status.

```sh
aws dynamodbstreams list-streams --table-name <YourDynamoDBTableName>
```

Validate permissions and stream settings. Ensure the IAM role has `dynamodb:DescribeStream`, `dynamodb:GetRecords`, `dynamodb:GetShardIterator`, `dynamodb:ListStreams` actions allowed.

#### Incorrect IAM Policy Attached

If operations are failing due to IAM policy issues.

Review the IAM policies attached to the user or role.

```sh
aws iam list-attached-role-policies --role-name <YourRoleName>
aws iam list-attached-user-policies --user-name <YourUserName>
```

Ensure that the required read, write, or stream policies are attached and configured correctly.

#### High GSI Read/Write Capacity Usage

When the GSI read or write capacity usage exceeds the threshold.

Check the ConsumedReadCapacityUnits and ConsumedWriteCapacityUnits metrics for the GSI to understand usage patterns.

```sh
aws cloudwatch get-metric-statistics --namespace AWS/DynamoDB --metric-name ConsumedReadCapacityUnits \
--dimensions Name=TableName,Value=<YourDynamoDBTableName> Name=GlobalSecondaryIndexName,Value=<YourGSIName> \
--start-time 2023-01-01T00:00:00Z --end-time 2023-01-02T00:00:00Z --period 300 --statistics Average
```

Scale the GSI read/write capacity based on the observed usage to prevent throttling.

