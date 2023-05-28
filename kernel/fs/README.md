




```c
#define sb_entry(list)	list_entry((list), struct super_block, s_list)
struct super_block {
	struct list_head	s_list;		 /* Keep this first, link all superblock */
	kdev_t				s_dev;            // 设备号
	unsigned long		s_blocksize;      // 块大小
	unsigned char		s_blocksize_bits; // 块大小占用的位
	unsigned char		s_lock;
	unsigned char		s_dirt;
	struct file_system_type	*s_type;  // 属于哪种文件系统
	struct super_operations	*s_op;    // 超级块的操作列表
	struct dquot_operations	*dq_op;   // 磁盘限额操作列表
	unsigned long		s_flags;
	unsigned long		s_magic;
	struct dentry		*s_root;      // 挂载的根目录dentry
	wait_queue_head_t	s_wait;

	struct list_head	s_dirty;	/* dirty inodes */
	struct list_head	s_files;

	struct block_device	*s_bdev;
	struct list_head	s_mounts;	/* vfsmount(s) of this one */
	struct quota_mount_options s_dquot;	/* Diskquota specific options */

	union {
		struct minix_sb_info	minix_sb;
		struct ext2_sb_info		ext2_sb;
		struct hpfs_sb_info		hpfs_sb;
		struct ntfs_sb_info		ntfs_sb;
		struct msdos_sb_info	msdos_sb;
		struct isofs_sb_info	isofs_sb;
		struct nfs_sb_info		nfs_sb;
		struct sysv_sb_info		sysv_sb;
		struct affs_sb_info		affs_sb;
		struct ufs_sb_info		ufs_sb;
		struct efs_sb_info		efs_sb;
		struct shmem_sb_info	shmem_sb;
		struct romfs_sb_info	romfs_sb;
		struct smb_sb_info		smbfs_sb;
		struct hfs_sb_info		hfs_sb;
		struct adfs_sb_info		adfs_sb;
		struct qnx4_sb_info		qnx4_sb;
		struct bfs_sb_info		bfs_sb;
		struct udf_sb_info		udf_sb;
		struct ncp_sb_info		ncpfs_sb;
		struct usbdev_sb_info   usbdevfs_sb;
		void					*generic_sbp;
	} u;
	/*
	 * The next field is for VFS *only*. No filesystems have any business
	 * even looking at it. You had been warned.
	 */
	struct semaphore s_vfs_rename_sem;	/* Kludge */

	/* The next field is used by knfsd when converting a (inode number based)
	 * file handle into a dentry. As it builds a path in the dcache tree from
	 * the bottom up, there may for a time be a subpath of dentrys which is not
	 * connected to the main tree.  This semaphore ensure that there is only ever
	 * one such free path per filesystem.  Note that unconnected files (or other
	 * non-directories) are allowed, but not unconnected diretories.
	 */
	struct semaphore s_nfsd_free_path_sem;
};
```

```c
struct inode {
	struct list_head		i_hash;   // link global inode hashtable
	struct list_head		i_list;
	struct list_head		i_dentry; // belongs to this inode's dentry list

	struct list_head		i_dirty_buffers;

	unsigned long			i_ino;
	atomic_t				i_count;
	kdev_t					i_dev;
	umode_t					i_mode;
	nlink_t					i_nlink;
	uid_t					i_uid;
	gid_t					i_gid;
	kdev_t					i_rdev;
	loff_t					i_size;
	time_t					i_atime;
	time_t					i_mtime;
	time_t					i_ctime;
	unsigned long			i_blksize;
	unsigned long			i_blocks;
	unsigned long			i_version;
	struct semaphore		i_sem;
	struct semaphore		i_zombie;
	struct inode_operations	*i_op;  // inode's operations
	struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
	struct super_block		*i_sb;  // belong to superblock
	wait_queue_head_t		i_wait;
	struct file_lock		*i_flock;
	struct address_space	*i_mapping;
	struct address_space	i_data;
	struct dquot			*i_dquot[MAXQUOTAS];
	struct pipe_inode_info	*i_pipe;
	struct block_device		*i_bdev;

	unsigned long			i_dnotify_mask; /* Directory notify events */
	struct dnotify_struct	*i_dnotify; /* for directory notifications */

	unsigned long			i_state;

	unsigned int			i_flags;
	unsigned char			i_sock;

	atomic_t				i_writecount;
	unsigned int			i_attr_flags;
	__u32					i_generation;
	union {
		struct minix_inode_info		minix_i;
		struct ext2_inode_info		ext2_i;
		struct hpfs_inode_info		hpfs_i;
		struct ntfs_inode_info		ntfs_i;
		struct msdos_inode_info		msdos_i;
		struct umsdos_inode_info	umsdos_i;
		struct iso_inode_info		isofs_i;
		struct nfs_inode_info		nfs_i;
		struct sysv_inode_info		sysv_i;
		struct affs_inode_info		affs_i;
		struct ufs_inode_info		ufs_i;
		struct efs_inode_info		efs_i;
		struct romfs_inode_info		romfs_i;
		struct shmem_inode_info		shmem_i;
		struct coda_inode_info		coda_i;
		struct smb_inode_info		smbfs_i;
		struct hfs_inode_info		hfs_i;
		struct adfs_inode_info		adfs_i;
		struct qnx4_inode_info		qnx4_i;
		struct bfs_inode_info		bfs_i;
		struct udf_inode_info		udf_i;
		struct ncp_inode_info		ncpfs_i;
		struct proc_inode_info		proc_i;
		struct socket				socket_i;
		struct usbdev_inode_info	usbdev_i;
		void						*generic_ip;
	} u;
};
```

```c
struct file {
	struct list_head		f_list;
	struct dentry			*f_dentry;
	struct vfsmount         *f_vfsmnt;
	struct file_operations	*f_op;
	atomic_t				f_count;
	unsigned int 			f_flags;
	mode_t					f_mode;
	loff_t					f_pos;
	unsigned long 			f_reada, f_ramax, f_raend, f_ralen, f_rawin;
	struct fown_struct		f_owner;
	unsigned int			f_uid, f_gid;
	int						f_error;

	unsigned long			f_version;

	/* needed for tty driver, and maybe others */
	void					*private_data;
};
```

