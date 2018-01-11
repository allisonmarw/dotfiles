Set up extension and repos

  $ echo "[phases]" >> $HGRCPATH
  $ echo "publish = False" >> $HGRCPATH
  $ echo "[extensions]" >> $HGRCPATH
  $ echo "remotenames=`dirname $TESTDIR`/remotenames.py" >> $HGRCPATH
  $ hg init repo1
  $ hg clone repo1 repo2
  updating to branch default
  0 files updated, 0 files merged, 0 files removed, 0 files unresolved
  $ cd repo2

Test that anonymous heads are disallowed by default

  $ echo a > a
  $ hg add a
  $ hg commit -m a
  $ hg push
  pushing to $TESTTMP/repo1 (glob)
  searching for changes
  abort: push would create new anonymous heads (cb9a9f314b8b)
  (use --allow-anon to override this warning)
  [255]

Test that config changes what is pushed by default

  $ echo b > b
  $ hg add b
  $ hg commit -m b
  $ hg up ".^"
  0 files updated, 0 files merged, 1 files removed, 0 files unresolved
  $ echo c > c
  $ hg add c
  $ hg commit -m c
  created new head
  $ hg push -r 'head()'
  pushing to $TESTTMP/repo1 (glob)
  searching for changes
  abort: push would create new anonymous heads (d2ae7f538514, d36c0562f908)
  (use --allow-anon to override this warning)
  [255]
  $ hg push -r .
  pushing to $TESTTMP/repo1 (glob)
  searching for changes
  abort: push would create new anonymous heads (d36c0562f908)
  (use --allow-anon to override this warning)
  [255]
  $ hg --config extensions.strip= strip d36c0562f908 d2ae7f538514
  0 files updated, 0 files merged, 1 files removed, 0 files unresolved
  saved backup bundle to $TESTTMP/repo2/.hg/strip-backup/d36c0562f908-ccf5bddc-*.hg (glob)

Test that config allows anonymous heads to be pushed

  $ hg push --config remotenames.pushanonheads=True
  pushing to $TESTTMP/repo1 (glob)
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files

Test that forceto works

  $ echo "[remotenames]" >> $HGRCPATH
  $ echo "forceto = True" >> $HGRCPATH
  $ hg push
  abort: must specify --to when pushing
  (see configuration option remotenames.forceto)
  [255]

Test that --to limits other options

  $ echo b >> a
  $ hg commit -m b
  $ hg push --to @ --rev . --rev ".^"
  abort: --to requires exactly one rev to push
  (use --rev BOOKMARK or omit --rev for current commit (.))
  [255]
  $ hg push --to @ --bookmark foo
  abort: do not specify --to/-t and --bookmark/-B at the same time
  [255]
  $ hg push --to @ --branch foo
  abort: do not specify --to/-t and --branch/-b at the same time
  [255]

Test that --create is required to create new bookmarks

  $ hg push --to @
  pushing rev 1846eede8b68 to destination $TESTTMP/repo1 bookmark @
  searching for changes
  abort: not creating new remote bookmark
  (use --create to create a new bookmark)
  [255]
  $ hg push --to @ --create
  pushing rev 1846eede8b68 to destination $TESTTMP/repo1 bookmark @
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files
  exporting bookmark @

Test that --non-forward-move is required to move bookmarks to odd locations

  $ hg push --to @
  pushing rev 1846eede8b68 to destination $TESTTMP/repo1 bookmark @
  searching for changes
  remote bookmark already points at pushed rev
  no changes found
  [1]
  $ hg push --to @ -r ".^"
  pushing rev cb9a9f314b8b to destination $TESTTMP/repo1 bookmark @
  searching for changes
  abort: pushed rev is not in the foreground of remote bookmark
  (use --non-forward-move flag to complete arbitrary moves)
  [255]
  $ hg up ".^"
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  $ echo c >> a
  $ hg commit -m c
  created new head
  $ hg push --to @
  pushing rev cc61aa6be3dc to destination $TESTTMP/repo1 bookmark @
  searching for changes
  abort: pushed rev is not in the foreground of remote bookmark
  (use --non-forward-move flag to complete arbitrary moves)
  [255]

Test that --non-forward-move allows moving bookmark around arbitrarily

  $ hg book -r 1 headb
  $ hg book -r 2 headc
  $ hg log -G -T '{rev} {desc} {bookmarks} {remotebookmarks}\n'
  @  2 c headc
  |
  | o  1 b headb default/@
  |/
  o  0 a
  
  $ hg push --to @ -r headb
  pushing rev 1846eede8b68 to destination $TESTTMP/repo1 bookmark @
  searching for changes
  remote bookmark already points at pushed rev
  no changes found
  [1]
  $ hg push --to @ -r headb
  pushing rev 1846eede8b68 to destination $TESTTMP/repo1 bookmark @
  searching for changes
  remote bookmark already points at pushed rev
  no changes found
  [1]
  $ hg push --to @ -r headc
  pushing rev cc61aa6be3dc to destination $TESTTMP/repo1 bookmark @
  searching for changes
  abort: pushed rev is not in the foreground of remote bookmark
  (use --non-forward-move flag to complete arbitrary moves)
  [255]
  $ hg push --to @ -r headc --non-forward-move --force
  pushing rev cc61aa6be3dc to destination $TESTTMP/repo1 bookmark @
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files (+1 heads)
  updating bookmark @
  $ hg push --to @ -r 0
  pushing rev cb9a9f314b8b to destination $TESTTMP/repo1 bookmark @
  searching for changes
  abort: pushed rev is not in the foreground of remote bookmark
  (use --non-forward-move flag to complete arbitrary moves)
  [255]
  $ hg push --to @ -r 0 --non-forward-move
  pushing rev cb9a9f314b8b to destination $TESTTMP/repo1 bookmark @
  searching for changes
  no changes found
  updating bookmark @
  [1]
  $ hg push --to @ -r headb
  pushing rev 1846eede8b68 to destination $TESTTMP/repo1 bookmark @
  searching for changes
  no changes found
  updating bookmark @
  [1]

Test that local must have rev of remote to push --to without --non-forward-move

  $ hg up -r 0
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  $ hg --config extensions.strip= strip -B headb
  saved backup bundle to $TESTTMP/repo2/.hg/strip-backup/1846eede8b68-61b88d4a-*.hg (glob)
  bookmark 'headb' deleted
  $ hg push --to @ -r headc
  pushing rev cc61aa6be3dc to destination $TESTTMP/repo1 bookmark @
  searching for changes
  abort: remote bookmark revision is not in local repo
  (pull and merge or rebase or use --non-forward-move)
  [255]

Clean up repo1

  $ cd ../repo1
  $ hg log -G -T '{rev} {desc} {bookmarks}\n'
  o  2 c
  |
  | o  1 b @
  |/
  o  0 a
  
  $ hg --config extensions.strip= strip 2
  saved backup bundle to $TESTTMP/repo1/.hg/strip-backup/cc61aa6be3dc-73e4f2eb-*.hg (glob)
  $ cd ../repo2

Test that rebasing and pushing works as expected

  $ hg pull
  pulling from $TESTTMP/repo1 (glob)
  searching for changes
  server has changed since last pull - falling back to the default search strategy
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files (+1 heads)
  (run 'hg heads' to see heads, 'hg merge' to merge)
  $ hg log -G -T '{rev} {desc} {bookmarks} {remotebookmarks}\n'
  o  2 b  default/@
  |
  | o  1 c headc
  |/
  @  0 a
  
  $ hg --config extensions.rebase= rebase -d default/@ -s headc 2>&1 | grep -v "^warning:" | grep -v incomplete
  rebasing 1:cc61aa6be3dc "c" (headc)
  merging a
  unresolved conflicts (see hg resolve, then hg rebase --continue)
  $ echo "a" > a
  $ echo "b" >> a
  $ echo "c" >> a
  $ hg resolve --mark a
  (no more unresolved files)
  $ hg --config extensions.rebase= rebase --continue
  rebasing 1:cc61aa6be3dc "c" (headc)
  saved backup bundle to $TESTTMP/repo2/.hg/strip-backup/cc61aa6be3dc-73e4f2eb-*.hg (glob)
  $ hg log -G -T '{rev} {desc} {bookmarks} {remotebookmarks}\n'
  o  2 c headc
  |
  o  1 b  default/@
  |
  @  0 a
  
  $ hg up headc
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  (activating bookmark headc)
  $ hg push --to @
  pushing rev 6683576730c5 to destination $TESTTMP/repo1 bookmark @
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files
  updating bookmark @
  $ hg log -G -T '{rev} {desc} {bookmarks} {remotebookmarks}\n'
  @  2 c headc default/@
  |
  o  1 b
  |
  o  0 a
  

Test that pushing over obsoleted changesets doesn't require --non-forward-move

  $ echo "[extensions]" >> $HGRCPATH
  $ echo "evolve=" >> $HGRCPATH
  $ echo d >> a
  $ hg commit --amend
  $ hg log --hidden -G -T '{rev} {desc} {bookmarks} {remotebookmarks}\n'
  @  4 c headc
  |
  | x  3 temporary amend commit for 6683576730c5
  | |
  | x  2 c  default/@
  |/
  o  1 b
  |
  o  0 a
  
  $ hg push --to @
  pushing rev d53f6666e0c4 to destination $TESTTMP/repo1 bookmark @
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files (+1 heads)
  2 new obsolescence markers
  updating bookmark @

Test that creating a new head with a remote bookmark is allowed without --force

  $ hg up -q '.^'
  $ hg push -q --to bm --create
  [1]
  $ echo e >> a
  $ hg commit -qm 'ea'
  $ hg push --to bm
  pushing rev d5bfa899fbbd to destination $TESTTMP/repo1 bookmark bm
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files (+1 heads)
  updating bookmark bm

Test that the forcecompat flag works

  $ hg push --to bm2 --force
  pushing rev d5bfa899fbbd to destination $TESTTMP/repo1 bookmark bm2
  searching for changes
  abort: not creating new remote bookmark
  (use --create to create a new bookmark)
  [255]
  $ hg push --to bm2 --force --config remotenames.forcecompat=True
  pushing rev d5bfa899fbbd to destination $TESTTMP/repo1 bookmark bm2
  searching for changes
  no changes found
  exporting bookmark bm2
  [1]

