
/ => all unauth access redirect to /login

/login

/tank(/list)?
/tank/add

/tank/NN/view
/tank/NN/edit

/tank/NN/watertest/add
/tank/NN/watertest/list
/tank/NN/watertest/MM/view
/tank/NN/watertest/MM/edit
/tank/NN/watertest/graph

/tank/NN/diary/add
/tank/NN/diary/list
/tank/NN/diary/MM/view

/tank/NN/inventory/add
/tank/NN/inventory/list
/tank/NN/inventory/MM/view
/tank/NN/inventory/MM/edit

## FIXME:
* consider having all index pages forward to /list automatically;
* remove all auto() methods that don't actually do anything;
* fix (or remove!) root/index method.
