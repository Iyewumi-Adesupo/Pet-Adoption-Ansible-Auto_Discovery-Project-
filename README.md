<h1 align="center" id="title">Pet Adoption Ansible Auto Discovery</h1>
<p id="description">Ensuring a secure environment is crucial during application development. Servers, databases, and other components must be shielded from unauthorized access. In this project, we implement a Bastion Host, also referred to as a "jump box," to enable secure SSH access to our application servers. This configuration places our servers within a private subnet with strictly controlled access.

Additionally, the project introduces the principle of least privilege, meaning user access rights are limited to the essentials required for their tasks.

In a highly available system, application servers are distributed across multiple availability zones. Each zone contains identically configured servers. This setup enables seamless redirection by the application load balancer to servers in another zone if one becomes unavailable. The project includes an Ansible bash script designed to detect and update newly provisioned instances, ensuring they run the latest version from our private Docker Hub repository.</p>
<p id="description">This README document provides a detailed guide, offering you a step-by-step process to effectively implement the Terraform code in this project. This results in the deployment of necessary resources in your AWS environment.

Moreover, this project adheres to modern DevOps best practices, emphasizing automated provisioning, scalability, high availability, and resilience. It enables developers and operators to collaboratively manage and enhance the lifecycle of the Java application, from development to deployment, utilizing the capabilities of AWS infrastructure.

By following these instructions, you will be well-prepared to initiate a sophisticated and adaptable deployment of the Java Application. You'll leverage advanced tools and cloud resources, ensuring optimal outcomes.
</p>
<p id="description">Here is the architectural diagram representing the project's objectives.</p>

![image](https://github.com/Iyewumi-Adesupo/Pet-Adoption-Ansible-Auto_Discovery-Project-/assets/135404420/19a82d45-64f8-41ae-a657-ef055e3f6473)
