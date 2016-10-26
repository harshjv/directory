![Nebulis Directory](https://cdn-images-1.medium.com/max/800/1*Fed06xjM5ubv8Q-pnE_KAQ.jpeg)

### Introduction

The Nebulis Directory is a blank-slate DNS built on the Ethereum blockchain. The goal of this project is to be the phonebook for the new web, compatible with a wide variety of content-addressed protocols such as the Interplanetary File System (IPFS), Storj, Swarm and MaidSafe, as well as HTTP.

### A Federated Structure

The Directory has a federated structure. The central Nebulis contract controls the creation of new clusters, which can be imagined as folders in a file system. Within a cluster, a domain can be created with accompanying A redirects. Alternatively, a subcluster can be created, to a maximum depth of 3 levels.

The traditional URL syntax follows a "specific => generic" pattern:

** scheme://subdomain.domain.tld/ **

Interplanetary Addresses (IPA's) on the other hand follows a "generic => specific" pattern:

** scheme://cluster.domain/ **

An IPA can have a maximum of 5 labels (3 cluster levels and 2 domain levels):

** scheme://cluster.subcluster.subcluster.domain.outerdomain/ **

"Outerdomain" is the equivalent of a subdomain in a URL.

This means that there is no name clash with the existing DNS system.

### The Home Clusters

When Nebulis is created, there will be 8 "home clusters" on which to register. These will be:

* /home
* /wallet
* /users
* /music
* /watch
* /learn
* /shop
* /public

An example if an IPA registered in one of these clusters would be ipfs://home.google | ipfs://shop.amazon | safe://learn.wikipedia. It should be noted that once one has an IPA ("learn.wikipedia") you can accompany it with an unlimited number of protocol schemes-to-redirects, which is indicated by the first prefix. So you can have "blog.leotolstoy" can have HTTP, IPFS, Safe, Swarm or Storj records associated with it.
