# Drop Framework

<img src="/docs/logo.png" align="right"></img>
> For Architecture, Anatomy, Best Tips and Usage, refer to [Drop AS3 Framework Website](http://jdanilov.github.io/drop/).

Minimalistic, hybrid MVC / IoC micro-architecture framework for ActionScript on Apache Flex and AIR platforms.

Drop derives from **PureMVC** in an attempt to minimize implementation approach discordance, forcing to write a strict, consistent and thus more safe code. Framework is designed to be brutally minimal and requires no boilerplate code to apply. Drop also introduces typed notification model and strong notion of *Separation of Concerns* concept.

Hybrid microarchitecture incorporates following approaches:
* **Inversion of Control** based on ServiceLocator, called `Context`;
* **Model / View / Controller** tiers coded in `Services` / `Mediators` / `Controller` classes respectively;
* **Strongly-typed Notification** & **Call Forwarding** model based on native interfaces.

Core framework design aspects:
* **Simplicity** - it takes very little effort to understand and start using the framework in real project;
* **Enforced Consistency** - architecture rules are very strict resulting in a more consistent and safe code produced by development teams. It is also naturally hard to misuse or misinterpret framework ideas;
* **Decoupling and Transparency** - framework improves code clarity, transparency and maintainability by exposing internal system API into a set of interfaces used to reduce modules coupling and keep the big picture in one place, easily and quickly accessible;
* **Minute Setup Time** - speaks for itself.

Free, Opensource, Apache license.
