use std::path::Path;
use std::ffi::OsStr;
use image::{ GenericImageView, io::Reader }; //, ImageBuffer,  imageops};
use rustler::{NifStruct};

#[derive(NifStruct, Debug)]
#[module = "Gi.Image"]
struct ImageSturct {
    pub path: String,
    pub ext: String,
    pub format: String,
    pub width: u32,
    pub height: u32,    
}

#[rustler::nif]
fn open(str: String)  {
    let ext = Path::new(&str).extension().and_then(OsStr::to_str);
    println!("ext {:?}",ext);
    let img = image::open(str.clone()).unwrap();
    let (width, height) = img.dimensions();
    println!("dimensions {:?}",(width, height));
    let ist = ImageSturct{path: str.clone(), width: width, height: height, ext: ext.unwrap().to_string(), format: ext.unwrap().to_string()};
    println!("ist {:#?}", ist);
    // return ist
    // let rrrr = Reader::open(str.clone())?.decode()?;
    println!("ist {:#?}", img.color());
}

rustler::init!("Elixir.Gi.Rust", [open]);
