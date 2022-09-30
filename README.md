[![Massdriver][logo]][website]

# aws-dynamodb-table

[![Release][release_shield]][release_url]
[![Contributors][contributors_shield]][contributors_url]
[![Forks][forks_shield]][forks_url]
[![Stargazers][stars_shield]][stars_url]
[![Issues][issues_shield]][issues_url]
[![MIT License][license_shield]][license_url]

<!--
##### STILL NEED TO GET SLACK WORKING ###
[!["Slack Community"](%s)][slack]
-->

DynamoDB table with options for managed or provisioned billing modes, simple or compound indexes, optional data stream for change data capture, and time to live for records.

---

## Design

For detailed information, check out our [Operator Guide](operator.mdx) for this bundle.

## Usage

Our bundles aren't intended to be used locally, outside of testing. Instead, our bundles are designed to be configured, connected, deployed and monitored in the [Massdriver][website] platform.

### What are Bundles?

Bundles are the basic building blocks of infrastructure, applications, and architectures in [Massdriver][website]. Read more [here](https://docs.massdriver.cloud/concepts/bundles).

## Bundle

### Params

Form input parameters for configuring a bundle for deployment.

<details>
<summary>View</summary>

<!-- PARAMS:START -->

## Properties

- **`capacity`** _(object)_
  - **`billing_mode`** _(string)_: Must be one of: `['PAY_PER_REQUEST', 'PROVISIONED']`. Default: `PAY_PER_REQUEST`.
- **`primary_index`** _(object)_
  - **`primary_index_type`** _(string)_: Must be one of: `['simple', 'compound']`. Default: `simple`.
- **`region`** _(string)_: AWS Region to provision in.

  Examples:

  ```json
  "us-west-2"
  ```

- **`stream`** _(object)_: Enable the emission of all changes to the database to a DynamoDB stream which can be consumed by a downstream service.
  - **`enabled`** _(boolean)_: Default: `False`.
- **`ttl`** _(object)_: Allows you to define a per-item timestamp to determine when an item is no longer needed. Shortly after the date and time of the specified timestamp, DynamoDB deletes the item from your table without consuming any write throughput. This value will be stored as a key called 'TTL'.
  - **`enabled`** _(boolean)_: Default: `False`.

## Examples

```json
{
  "__name": "Free Tier",
  "capacity": {
    "billing_mode": "PROVISIONED",
    "read_capacity": 25,
    "write_capacity": 25
  },
  "primary_index": {
    "partition_key": "ID",
    "partition_key_type": "S",
    "type": "simple"
  },
  "region": "us-west-2",
  "ttl": {
    "enabled": true
  }
}
```

```json
{
  "__name": "Pay Per Request",
  "capacity": {
    "billing_mode": "PAY_PER_REQUEST"
  },
  "primary_index": {
    "partition_key": "ID",
    "partition_key_type": "S",
    "type": "simple"
  },
  "region": "us-west-2"
}
```

```json
{
  "__name": "Compound Index",
  "capacity": {
    "billing_mode": "PAY_PER_REQUEST"
  },
  "primary_index": {
    "partition_key": "ID",
    "partition_key_type": "S",
    "sort_key": "Date",
    "sort_key_type": "S",
    "type": "compound"
  },
  "region": "us-west-2"
}
```

```json
{
  "__name": "With TTL",
  "capacity": {
    "billing_mode": "PAY_PER_REQUEST"
  },
  "primary_index": {
    "partition_key": "ID",
    "partition_key_type": "S",
    "sort_key": "Date",
    "sort_key_type": "S",
    "type": "compound"
  },
  "region": "us-west-2"
}
```

```json
{
  "__name": "With Streams",
  "capacity": {
    "billing_mode": "PAY_PER_REQUEST"
  },
  "primary_index": {
    "partition_key": "ID",
    "partition_key_type": "S",
    "sort_key": "Date",
    "sort_key_type": "S",
    "type": "compound"
  },
  "region": "us-west-2",
  "stream": {
    "enabled": true,
    "view_type": "KEYS_ONLY"
  }
}
```

<!-- PARAMS:END -->

</details>

### Connections

Connections from other bundles that this bundle depends on.

<details>
<summary>View</summary>

<!-- CONNECTIONS:START -->

## Properties

- **`authentication`** _(object)_: . Cannot contain additional properties.

  - **`data`** _(object)_

    - **`arn`** _(string)_: Amazon Resource Name.

      Examples:

      ```json
      "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
      ```

      ```json
      "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
      ```

    - **`external_id`** _(string)_: An external ID is a piece of data that can be passed to the AssumeRole API of the Security Token Service (STS). You can then use the external ID in the condition element in a role's trust policy, allowing the role to be assumed only when a certain value is present in the external ID.

  - **`specs`** _(object)_

    - **`aws`** _(object)_: .

      - **`region`** _(string)_: AWS Region to provision in.

        Examples:

        ```json
        "us-west-2"
        ```

      - **`resource`** _(string)_
      - **`service`** _(string)_
      - **`zone`** _(string)_: AWS Availability Zone.

            Examples:

        <!-- CONNECTIONS:END -->

</details>

### Artifacts

Resources created by this bundle that can be connected to other bundles.

<details>
<summary>View</summary>

<!-- ARTIFACTS:START -->

## Properties

    <!-- ARTIFACTS:END -->

</details>

## Contributing

<!-- CONTRIBUTING:START -->

### Bug Reports & Feature Requests

Did we miss something? Please [submit an issue](https://github.com/massdriver-cloud/aws-sqs-pubsub-subscription/issues) to report any bugs or request additional features.

### Developing

**Note**: Massdriver bundles are intended to be tightly use-case scoped, intention-based, reusable pieces of IaC for use in the [Massdriver][website] platform. For this reason, major feature additions that broaden the scope of an existing bundle are likely to be rejected by the community.

Still want to get involved? First check out our [contribution guidelines](https://docs.massdriver.cloud/bundles/contributing).

### Fix or Fork

If your use-case isn't covered by this bundle, you can still get involved! Massdriver is designed to be an extensible platform. Fork this bundle, or [create your own bundle from scratch](https://docs.massdriver.cloud/bundles/development)!

<!-- CONTRIBUTING:END -->

## Connect

<!-- CONNECT:START -->

Questions? Concerns? Adulations? We'd love to hear from you!

Please connect with us!

[![Email][email_shield]][email_url]
[![GitHub][github_shield]][github_url]
[![LinkedIn][linkedin_shield]][linkedin_url]
[![Twitter][twitter_shield]][twitter_url]
[![YouTube][youtube_shield]][youtube_url]
[![Reddit][reddit_shield]][reddit_url]

<!-- markdownlint-disable -->

[logo]: https://raw.githubusercontent.com/massdriver-cloud/docs/main/static/img/logo-with-logotype-horizontal-400x110.svg
[docs]: https://docs.massdriver.cloud/?utm_source=github&utm_medium=readme&utm_campaign=aws-dynamodb-table&utm_content=docs
[website]: https://www.massdriver.cloud/?utm_source=github&utm_medium=readme&utm_campaign=aws-dynamodb-table&utm_content=website
[github]: https://github.com/massdriver-cloud?utm_source=github&utm_medium=readme&utm_campaign=aws-dynamodb-table&utm_content=github
[slack]: https://massdriverworkspace.slack.com/?utm_source=github&utm_medium=readme&utm_campaign=aws-dynamodb-table&utm_content=slack
[linkedin]: https://www.linkedin.com/company/massdriver/?utm_source=github&utm_medium=readme&utm_campaign=aws-dynamodb-table&utm_content=linkedin
[contributors_shield]: https://img.shields.io/github/contributors/massdriver-cloud/aws-dynamodb-table.svg?style=for-the-badge
[contributors_url]: https://github.com/massdriver-cloud/aws-dynamodb-table/graphs/contributors
[forks_shield]: https://img.shields.io/github/forks/massdriver-cloud/aws-dynamodb-table.svg?style=for-the-badge
[forks_url]: https://github.com/massdriver-cloud/aws-dynamodb-table/network/members
[stars_shield]: https://img.shields.io/github/stars/massdriver-cloud/aws-dynamodb-table.svg?style=for-the-badge
[stars_url]: https://github.com/massdriver-cloud/aws-dynamodb-table/stargazers
[issues_shield]: https://img.shields.io/github/issues/massdriver-cloud/aws-dynamodb-table.svg?style=for-the-badge
[issues_url]: https://github.com/massdriver-cloud/aws-dynamodb-table/issues
[release_url]: https://github.com/massdriver-cloud/aws-dynamodb-table/releases/latest
[release_shield]: https://img.shields.io/github/release/massdriver-cloud/aws-dynamodb-table.svg?style=for-the-badge
[license_shield]: https://img.shields.io/github/license/massdriver-cloud/aws-dynamodb-table.svg?style=for-the-badge
[license_url]: https://github.com/massdriver-cloud/aws-dynamodb-table/blob/main/LICENSE
[email_url]: mailto:support@massdriver.cloud
[email_shield]: https://img.shields.io/badge/email-Massdriver-black.svg?style=for-the-badge&logo=mail.ru&color=000000
[github_url]: mailto:support@massdriver.cloud
[github_shield]: https://img.shields.io/badge/follow-Github-black.svg?style=for-the-badge&logo=github&color=181717
[linkedin_url]: https://linkedin.com/in/massdriver-cloud
[linkedin_shield]: https://img.shields.io/badge/follow-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&color=0A66C2
[twitter_url]: https://twitter.com/massdriver?utm_source=github&utm_medium=readme&utm_campaign=aws-dynamodb-table&utm_content=twitter
[twitter_shield]: https://img.shields.io/badge/follow-Twitter-black.svg?style=for-the-badge&logo=twitter&color=1DA1F2
[discourse_url]: https://community.massdriver.cloud?utm_source=github&utm_medium=readme&utm_campaign=aws-dynamodb-table&utm_content=discourse
[discourse_shield]: https://img.shields.io/badge/join-Discourse-black.svg?style=for-the-badge&logo=discourse&color=000000
[youtube_url]: https://www.youtube.com/channel/UCfj8P7MJcdlem2DJpvymtaQ
[youtube_shield]: https://img.shields.io/badge/subscribe-Youtube-black.svg?style=for-the-badge&logo=youtube&color=FF0000
[reddit_url]: https://www.reddit.com/r/massdriver
[reddit_shield]: https://img.shields.io/badge/subscribe-Reddit-black.svg?style=for-the-badge&logo=reddit&color=FF4500

<!-- markdownlint-restore -->

<!-- CONNECT:END -->
