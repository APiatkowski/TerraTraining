# AWS Orientation

In these (and all of the following) exercises, you use your AWS account. Please verify if you're using the correct account and have the trainer verify that your account has been given permissions to access the AWS Services.

## Exercises

### AWS Console & Creating access keys for automation

1. Login to [AWS Console](https://console.aws.amazon.com/).
1. Set as follows:
    1. Account ID: `sodo-mrostanski`
    1. IAM user name: `<given by the instructor>`
    1. Password: `<given by the instructor>`    
1. In the top right side of the screen, select the `eu-central-1` (Frankfurt) region. It is the most important to always work within the same region selected for training purposes, and if something seems missing, always check if you're looking at the right region!.
1. In the top navigation bar, input "IAM" and click the `IAM` option that will be shown as hint.
1. You will find yourself in the IAM service dashboard that shows the most important information on the account's security. You can always use the same method for navigation to any other service to open its dashboard.
1. On the IAM dashboard screen, locate `Users` on the left and find your user on the list. Click the name to open the user summary. 
1. From the navigation menu in the middle, choose "Security credentials" tab.
1. In the "Access keys" section, choose "Create access key" option.
1. In the dialog window that follows, make sure you have copied both the access key ID as well as secret access key onto your workstation, or better, download the `.csv` file.
1. You can close the dialog and proceed to work with AWS CLI.

### AWS CLI & Creating an S3 bucket

1. Install AWSCLIv2 using original [documentation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
1. Verify with:

    ```bash
    aws --version
    aws-cli/2.1.27 Python/3.7.3 Linux/5.8.0-55-generic exe/x86_64.linuxmint.20 prompt/off
    ```

1. Create a profiled configuration with a command:

    ```bash
    aws configure --profile sodo

    AWS Access Key ID [None]: <YOUR_ACCESS_KEY>
    AWS Secret Access Key [None]: <YOUR_SECRET_KEY>
    Default region name [None]: eu-central-1
    Default output format [None]: text
    ```

1. Verify the contents of two files:
    1. `~/.aws/credentials`
    2. `~/.aws/config`   
1. Verify that your keys work by listing S3 buckets in our AWS account:

    ```bash
    aws s3 ls --profile sodo

    2021-09-22 20:18:10 your-aws-cli-works-fine
    ```

1. Create a bucket and list the buckets again:

    ```bash
    aws s3api create-bucket --bucket pick-your-name-of-the-bucket --region us-east-1 --profile sodo
    aws s3 ls --profile sodo
    ```

1. Delete the bucket to finish the exercise.

    ```bash
    aws s3api delete-bucket --bucket this-is-the-test-bucket --region us-east-1 --profile sodo
    ```


Additional links:

[AWS CLI Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html#cli-aws)