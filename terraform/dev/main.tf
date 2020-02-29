
module "dbs" {
  source         = "./databases/"
}


module "web" {
  source         = "./web/"
}


module "kuber" {
  source         = "./kuber/"
}