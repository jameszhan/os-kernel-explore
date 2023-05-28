

```c
struct dquot_operations {
	void (*initialize) (struct inode *, short);
	void (*drop) (struct inode *);
	int (*alloc_block) (const struct inode *, unsigned long, char);
	int (*alloc_inode) (const struct inode *, unsigned long);
	void (*free_block) (const struct inode *, unsigned long);
	void (*free_inode) (const struct inode *, unsigned long);
	int (*transfer) (struct dentry *, struct iattr *);
};
```


```c
struct dquot {
	struct hlist_node dq_hash;	/* Hash list in memory [dq_list_lock] */
	struct list_head dq_inuse;	/* List of all quotas [dq_list_lock] */
	struct list_head dq_free;	/* Free list element [dq_list_lock] */
	struct list_head dq_dirty;	/* List of dirty dquots [dq_list_lock] */
	struct mutex dq_lock;		/* dquot IO lock */
	spinlock_t dq_dqb_lock;		/* Lock protecting dq_dqb changes */
	atomic_t dq_count;		/* Use count */
	struct super_block *dq_sb;	/* superblock this applies to */
	struct kqid dq_id;		/* ID this applies to (uid, gid, projid) */
	loff_t dq_off;			/* Offset of dquot on disk [dq_lock, stable once set] */
	unsigned long dq_flags;		/* See DQ_* */
	struct mem_dqblk dq_dqb;	/* Diskquota usage [dq_dqb_lock] */
};

/* Operations working with dquots */
struct dquot_operations {
	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
	struct dquot *(*alloc_dquot)(struct super_block *, int);	/* Allocate memory for new dquot */
	void (*destroy_dquot)(struct dquot *);		/* Free memory for dquot */
	int (*acquire_dquot) (struct dquot *);		/* Quota is going to be created on disk */
	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
	/* get reserved quota for delayed alloc, value returned is managed by quota code only */
	qsize_t *(*get_reserved_space) (struct inode *);
	int (*get_projid) (struct inode *, kprojid_t *);/* Get project ID */
	/* Get number of inodes that were charged for a given inode */
	int (*get_inode_usage) (struct inode *, qsize_t *);
	/* Get next ID with active quota structure */
	int (*get_next_id) (struct super_block *sb, struct kqid *qid);
};
```