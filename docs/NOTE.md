# Notes de cadrage : Portage AWS

## Participants

* WeScale
* Nova Technology

## Session du 2022-02-18

En vue du portage du projet vers une infrastructure AWS:

* consommer moins d'ip
    * se baser sur des ALB et CNAME au niveau de R53
* rendre le bind optionnel (remplacable par route53)
    * gestion des certifs possible avec ACM
* unseal du vault paramétrable (AWS KMS)
* nom des roles galaxie a rendre parametrable (extensible par liste)
* balisage des secrets (mix en 2 repo git)
    * repo travail avec data et ansible-vault pour chiffrer tous les fichiers sensibles (systématique en fin de playbook)
    * repo code == dependances ansible-galaxy
* procedure de recuperation d'acces entre operateur et consommateur
    * procedure de rekey

* documenter le threat model avec les risques sur la gestion des secrets
