Rolling your Own Mocks and Stubs
================

Presentations
---
**2014/03/13** [Cookpad](http://www.meetup.com/tokyo-rails/events/166222312/)


About the Presentation
---

RSpec and mocha give you great tools for stubbing and mocking the behavior of your dependencies to give you all of the benefits of isolated testing.

Over-replying on these techniques, however, can bind the interface of your mocks to your specs, and allow them to more easily fall out-of-line with the expectations of your real objects. There's a better way!

By looking at the quality and understandability of your sepcs, you can better understand how to group functionality and not mix levels of abstractions—specs shouldn't be ugly or hard to change!

This talk uses an example of processing payments from [Stripe](https://stripe.com).


Running The Examples
---

You can run all of the examples that I use in the talk.

You'll need Ruby 2.1 to run the code. You can use [rvm](http://rvm.io) or [rbenv](https://github.com/sstephenson/rbenv) to upgrade your Ruby version.

To get started, first install the gems:

```
$ bundle install
```

then, you can toggle between the versions of the code I presented (versions 1 through 8):


```
$ ./switch_version 3
```

and execute the specs to see that they pass:


```
$ rspec spec
```


Try editing them to add your own features or specs!

Resources
----

**Gems**
* [RSpec](https://github.com/rspec/rspec)
* [WebMock](https://github.com/bblimke/webmock)
* [Surrogate](https://github.com/JoshCheek/surrogate)
* [Deject](https://github.com/JoshCheek/deject)

**Articles & Documentation**
* [Three Reasons to Roll Your Own Mocks](http://blog.8thlight.com/josh-cheek/2011/11/28/three-reasons-to-roll-your-own-mocks.html)
* [Stripe Charge API](https://stripe.com/docs/api/curl#charges)
