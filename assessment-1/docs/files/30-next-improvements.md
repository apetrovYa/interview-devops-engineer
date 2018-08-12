# Improvements

No software project is free of improvements because of difficulty to get the
complete set of software requirements from the first time. And as long as the
software is in use by someone, its requirements will change accordingly.

For this little project, I identified the following areas and objects of improvement:

- *Deployment script*: this script is implemented in a procedural programming style.
  Because I became more aware about the PowerShell features, I would like to
  refactor it using Object Oriented Design techniques and code it using the
  Object Oriented programming style. The idea is to create a little framework
  to ease the definition, maintainability and testing of this and any other
  future depolyment script in PowerShell.

    - Here, some awarenesses are the management of classes in PowerShell.
      PowerShell requires to load the base classes before any derived classes.
      So, how I can do it In Azure PowerShell, Linux environment or Windows.
      (Containers?) Also, here I have to understand where to store them and 
      how to share between different projects. One solution can be PowerShell
      modules; but I have to figure out a more clear idea. Here again maybe
      container are a good fit.

- *Standardize the development environment*: here I have to understand if it is
   better to develop in Azure PowerShell directly or on a local machine, be it
   Linux or Windows.

- *Security*: this is an important topic. For example, in case the orchestration
   machines are on-prem, I have to understand if there are some form of vulnerabilities
   that can compromise the entire environment. Also, I have to validate the current
   script if it can be compromised.

- *Testing*: Once the deployment script will be refactored, will be easier to write
   down the tests, in the last moment of the writing I improved my familiarity with
   the scripting environment. For this cause, I found the Pester tool for testing
   PowerShell scripts.


The previous bullet list is only a subset of the improvements that can be done.
There can be many more, they need to be ellicited.

Following the [this](./40-final-balance.md) link, you will get the final balance about the invested
working hours.