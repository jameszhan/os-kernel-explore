```c
struct address_space_operations {
	int (*writepage)(struct page *);
	int (*readpage)(struct file *, struct page *);
	int (*sync_page)(struct page *);
	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
	int (*bmap)(struct address_space *, long);
};
```

```c
struct address_space_operations {
	int (*writepage)(struct page *page, struct writeback_control *wbc);
	int (*read_folio)(struct file *, struct folio *);

	/* Write back some dirty pages from this mapping. */
	int (*writepages)(struct address_space *, struct writeback_control *);

	/* Mark a folio dirty.  Return true if this dirtied it */
	bool (*dirty_folio)(struct address_space *, struct folio *);

	void (*readahead)(struct readahead_control *);

	int (*write_begin)(struct file *, struct address_space *mapping, loff_t pos, unsigned len, struct page **pagep, void **fsdata);
	int (*write_end)(struct file *, struct address_space *mapping, loff_t pos, unsigned len, unsigned copied, struct page *page, void *fsdata);

	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
	sector_t (*bmap)(struct address_space *, sector_t);
	void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
	bool (*release_folio)(struct folio *, gfp_t);
	void (*free_folio)(struct folio *folio);
	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
	/*
	 * migrate the contents of a folio to the specified target. If
	 * migrate_mode is MIGRATE_ASYNC, it must not block.
	 */
	int (*migrate_folio)(struct address_space *, struct folio *dst, struct folio *src, enum migrate_mode);
	int (*launder_folio)(struct folio *);
	bool (*is_partially_uptodate) (struct folio *, size_t from, size_t count);
	void (*is_dirty_writeback) (struct folio *, bool *dirty, bool *wb);
	int (*error_remove_page)(struct address_space *, struct page *);

	/* swapfile support */
	int (*swap_activate)(struct swap_info_struct *sis, struct file *file, sector_t *span);
	void (*swap_deactivate)(struct file *file);
	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
};
```