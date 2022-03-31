
## indeces
- balanced binary tree - indexes
- linear / full table scan - no indexes
- table may consist of several partitions, if of which can be either stored as a heap or a B-tree structure
- index operate on column(s)

- unieuq cocl + include non-unique col
- execution  plan
- no to indexes on columns that may be cchanged frequently - index has to be rebuilt each time
- no to usage of too many indexes
- clustered index and nonclustered indexes for foreign keys
- table without clustered index is a heap (there is no order for data)
- clustered points at real data pages
- non-clustered points at heaps or clustered index

## optimizing queries
- alternative to queres with sorting are indexes
- are more optimal than or ???
- it is better to use where than group + having if there is no aggregate function in the having clause
- view in view is evil

## transactions
- transaction is atomic (or every query will be performed or none)
- consistency : commit state_1 - > state_2 (all constrains should be valid)
- isolation : should appear as being executed in isolation
- durability : changes after commit must not be lost of any failture
- a lot of instraction have autocommit : remember on that and use explicit transactions

lock and isolation
- transaction level read uncommited
    - dirty read
- repetable read : no one may to change data while one reads this (takes lock)
- serializable : block not only modifying but also addition


