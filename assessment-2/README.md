# Assessment 2

## Problem statement

A client has an interface published, based on a node.js application.
This application runs on a host with NGINX. Another process is also
running for batch processing for asynchronous message replication.
The application is making use of a MongoDB database.

This system connects with a back-end within the customers secured private network.
The data handled in this case by the specific applications is however permitted
to be handled and transferred in and over public networks, as long the data is
encrypted during every stage of the process. The back-end needs to remain secure.

The client has a strong public cloud policy, where everything is preferably
placed in a public cloud. A large contract is in place with Microsoft, however,
depending on the specific case AWS is also allowed as a public cloud vendor.

The application is maintained by a team with a strong background of software
engineering on top of Heroku. This team will remain to be responsible for the
software engineering & -maintenance of this front-end.

The client desire a new environment for this application. They have had problems
in the past regarding performance. The application couldn't handle the load during
peak moments. There were also incidents where incoming messages have disappeared
before they were actually processed. Availability, in general, was also an issue.

## Output

A technical design for the setup of this environment, including deployment
mechanism and appropriate required environments

## Notes

You can find all the assumptions, the interpretations and designs I made in
the attached here [PDF file](./sentia-tech-interview-assessment-2.pdf).