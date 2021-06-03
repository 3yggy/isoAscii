////////////////////////////////

//how much screen x increases with unit x
const xMarginalx=4;
//screen width of block beyond marginal value
const xMargin=blockStrWidth-xMarginalx;

//how much screen x !decreases! with unit y
const xMarginaly=2;

//how much screen y increases with unit y
const yMarginaly=1;
//screen height of block beyond marginal value
const yMargin=blockStr.len-yMarginaly;

//how much screen y !decreases! with unit of z
const yMarginalz=2;

const yPad=0;

////////////////////////////////

const std = @import("std");

const blockStr = [_][]const u8{
" ,----,",
"+===+'|",      
"|   | ;",    
"+===+' ",    
};
const blockStrWidth = blockStr[0].len;

const stride=5;
const height=9;
const blocks=[_]u8
{   35, 40,45,40,35,
    30, 25,24,23,25,
    30,20,21,22,15,
    30,19,18,17,12,
    30, 14, 15, 16,11,
    30,13,12,11,10,
    1, 8, 9,10,10,
    7, 6, 5, 4,10,
    0, 1, 2, 3,10,
};
const maxHeight = 45;

const rearOffset=(height-1)*xMarginaly;
const canWidth=xMarginalx*stride+rearOffset+xMargin;
const bottom=(maxHeight-1)*yMarginalz+yPad;
const canHeight=maxHeight*yMarginalz+height*yMarginaly+1+yPad*2;


var result: [canHeight][canWidth]u8 = undefined;

pub fn main() !void {
    var h:u32 = 0;
    var used = true;
    while(used) : (h+=1){
        used = false;
        for(blocks) |b,n|{
            const x:usize = n%stride;
            const y:usize = n/stride;
            if(h<=maxHeight and b>h){
                try stamp(x,y,h);
                used=true;
            }
        }
    }
    for(result) |line, i| {
        std.debug.print("* {s} *{d}\n",.{line,i/yMarginalz});
    }
}

fn stamp(x:usize,y:usize,z:usize) !void {
    var stringX:usize=rearOffset+x*xMarginalx-y*xMarginaly; 
    var stringY:usize=bottom+y*yMarginaly-z*yMarginalz;
    for(blockStr) |line, i| {
        if(i==0){
            result[stringY+i][stringX..][1..blockStrWidth].* = blockStr[i][1..blockStrWidth].*;
        }else if(i==3){
            result[stringY+i][stringX..][0..blockStrWidth-1].* = blockStr[i][0..blockStrWidth-1].*;
        }else{
            result[stringY+i][stringX..][0..blockStrWidth].* = blockStr[i][0..blockStrWidth].*;
        }
    }
}
