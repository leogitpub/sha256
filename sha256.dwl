/*
 * `sha256.dwl`, an implementation written purely in Dataweave by `Omkaram Venkatesh`, August 2021. All Rights Reserved.
 * 
 * 
 * This piece of work is entirely written from scratch by the Author who is mentioned above, and it does not contain any external code references.
 * 
 * SHA-256 message digest is a very popular and a widely used Cryptographic Hash Algorithm. There are a variety of ways one can achieve this implementation, 
 * but the main goal here is to do SHA256 in one single script file by extensively using tail recursions in a way that no one could ever think of.
 * 
 * This work does not fall under any licensing category of the Open Source Community. The license is proprietary. 
 * 
 * Unauthorized distribution, redistribution, based on the original work, or the modified work, by the Author or Other Parties (contributors), and usage of this file or code for any reason, via any medium, is strictly prohibited.
 * Neither the Author or the Contributors of this work is responsible for any damages caused by this code, either directly or indirectly, for such usage committed in violation of the above licensing statements. 
 * Only read and `modification for contribution`, such permissions are allowed.
 * 
 *
 * For any permissions related to this work (like distribution and usage), please contact the Author at https://omkaram.net
 *
 *       THIS LICENSE STATEMENT MUST NOT BE MODIFIED, REMOVED OR DETACHED FROM THE BELOW CODE UNDER ANY CIRCUMSTANCES. 
 *                                      THIS STATEMENT MUST BE CARRIED AS IS.
 *
 * <-------------------------------------- Explore the Power of Dataweave ------------------------------------------->
 */

import dw::core::Numbers
import * from dw::core::Strings
import * from dw::core::Arrays
import toHex as sTh0, fromHex as hTs64 from dw::core::Binaries
import fromHex as hTd, fromBinary as bTd, toBinary as dTb from dw::core::Numbers
import dw::core::Numbers
import dw::core::Strings


var sTh = (p1) -> sTh0(p1) as String
var hTs = (p1) -> hTs64(p1) as String
var dTh = (p1) -> sTh0((p1 as Number)) as String
var bThex = (ax) ->  (pad32(ax) splitBy ("") divideBy  4 map (sTh0(bTd($ joinBy ""))[1]) joinBy(""))
var pad32 = (p1) -> leftPad(p1, 32, 0)
var pa = (k: Number, jj, arr: Array<Number>=[]) -> if(k > jj-1) pa(k-1, jj, (arr + k)) else arr
var sigPadd = (p) -> if((sizeOf(p) mod 8) != 0) leftPad(p,((sizeOf(p) mod 8) + (8*(ceil(sizeOf(p)/8)) - (sizeOf(p) mod 8))), 0) else (p)

var K = ["428a2f98","71374491","b5c0fbcf","e9b5dba5","3956c25b","59f111f1","923f82a4","ab1c5ed5",
		"d807aa98","12835b01","243185be","550c7dc3","72be5d74","80deb1fe","9bdc06a7","c19bf174",
		"e49b69c1","efbe4786","0fc19dc6","240ca1cc","2de92c6f","4a7484aa","5cb0a9dc","76f988da",
		"983e5152","a831c66d","b00327c8","bf597fc7","c6e00bf3","d5a79147","06ca6351","14292967",
		"27b70a85","2e1b2138","4d2c6dfc","53380d13","650a7354","766a0abb","81c2c92e","92722c85",
		"a2bfe8a1","a81a664b","c24b8b70","c76c51a3","d192e819","d6990624","f40e3585","106aa070",
		"19a4c116","1e376c08","2748774c","34b0bcb5","391c0cb3","4ed8aa4a","5b9cca4f","682e6ff3",
		"748f82ee","78a5636f","84c87814","8cc70208","90befffa","a4506ceb","bef9a3f7","c67178f2"]

var a = "6A09E667"
var b = "BB67AE85"
var c = "3C6EF372"
var d = "A54FF53A"
var e = "510E527F"
var f = "9B05688C"
var g = "1F83D9AB"
var h = "5BE0CD19"

var Initial_V = ["6A09E667","BB67AE85","3C6EF372","A54FF53A","510E527F","9B05688C","1F83D9AB","5BE0CD19"]

fun AND(lo: Number, ro: Number) = do {
    var binary = getBin(lo, ro)
    ---
    Numbers::fromBinary(binary.left map ($ as Number * binary.right[$$] as Number) reduce ($$++$))
}
fun OR(lo: Number, ro: Number) = do {
    var binary = getBin(lo, ro)
    ---
    Numbers::fromBinary(binary.left map (if ($ == "1" or binary.right[$$] == "1") "1" else "0") reduce ($$++$))
}

fun XOR(lo: Number, ro: Number) = do {
    var binary = getBin(lo, ro)
    ---
    Numbers::fromBinary(binary.left map (if ($ == binary.right[$$]) "0" else "1") reduce ($$++$))
}

fun getBin(lo: Number, ro: Number) = do {
    var loB = Numbers::toBinary(lo)
    var roB = Numbers::toBinary(ro)
    var size = max([sizeOf(loB), sizeOf(roB)]) default 0
    ---
    { 
        left: Strings::leftPad(loB, size, '0') splitBy '',
        right: Strings::leftPad(roB, size, '0') splitBy ''
    }
}

fun getBinary(lo: Number, ro: Number, po: Number=0) = do {
    var loB = Numbers::toBinary(lo)
    var roB = Numbers::toBinary(ro)
    var poB = Numbers::toBinary(po)
    var size = max([sizeOf(loB), sizeOf(roB), sizeOf(poB)]) default 0
    ---
    { 
        left: Strings::leftPad(loB, size, '0') splitBy '',
        right: Strings::leftPad(roB, size, '0') splitBy '',
        last: if(po != 0) Strings::leftPad(poB, size, '0') splitBy '' else "",
    }
}

fun XOR(lo: Number, ro: Number) = do {
    var binary = getBinary(lo, ro)
    ---
    Numbers::fromBinary(binary.left map (if ($ == binary.right[$$]) "0" else "1") reduce ($$++$))
}

fun SHR(a, b) = do {
var sizeOfBinary = sizeOf((Numbers::toBinary(a) splitBy("")))
var shiftArrayBinay = (k: Number, arr: Array<String>=(Numbers::toBinary(a) splitBy(""))) -> 
		if(k > 0)  shiftArrayBinay(k-1, ("0" >> arr)[0 to sizeOfBinary]) else (arr[0 to (sizeOfBinary)-1] joinBy  (""))
---
 shiftArrayBinay(b)
}

fun SHL(a, b) = do {
var sizeOfBinary = sizeOf((Numbers::toBinary(a) splitBy("")))
var shiftArrayBinay = (k: Number, arr: Array<String>=(Numbers::toBinary(a) splitBy(""))) -> 
		if(k > 0)  shiftArrayBinay(k-1, (arr << "0")[-1 to -sizeOfBinary][-1 to 0]) else (arr[0 to (sizeOfBinary)-1] joinBy  (""))
---
 shiftArrayBinay(b)
}

fun ROTR(a, b) = do {
var sizeOfBinary = sizeOf((pad32(Numbers::toBinary(a)) splitBy("")))
var shiftArrayBinay = (k: Number, j=0, arr: Array<String>=(pad32(Numbers::toBinary(a)) splitBy(""))) -> 
		if(k > 0)  shiftArrayBinay(k-1, j+1, (arr[-1] >> arr)[0 to sizeOfBinary-1]) else (if(j == 0) arr[0 to (sizeOfBinary)-1] joinBy  ("") else arr[0 to (sizeOfBinary)-1] joinBy  (""))
---
 shiftArrayBinay(b)
}

fun ROTL(a, b) = do {
var sizeOfBinary = sizeOf((pad32(Numbers::toBinary(a)) splitBy("")))
var shiftArrayBinay = (k: Number, j=0, arr: Array<String>=(pad32(Numbers::toBinary(a)) splitBy(""))) -> 
		if(k > 0)  shiftArrayBinay(k-1, j+1, (arr << arr[0])[-1 to -sizeOfBinary][-1 to 0]) else (if(j == 0) arr[0 to (sizeOfBinary)-1] joinBy  ("") else arr[0 to (sizeOfBinary)-1] joinBy  (""))
---
 shiftArrayBinay(b)
}

fun Ch(lo: Number, ro: Number, po: Number) = do {
    var binary = getBinary(lo, ro, po)
    ---
    Numbers::fromBinary(binary.left map (if ($ == "1") binary.right[$$] else binary.last[$$]) reduce($$ ++ $)
    )}

fun Maj(lo: Number, ro: Number, po: Number) = do {
    var binary = getBinary(lo, ro, po)
    var arr = (binary.left map {
 					arr: ([$] << binary.right[$$] << binary.last[$$])
    			}).arr map $ 
    ---
    Numbers::fromBinary((arr map  ($ countBy ($ ~= 1))) map(if($ > 1) 1 else 0) reduce($$ ++ $))
    }


fun Sig0(p1) = pad32(dTb(XOR((XOR(bTd(sigPadd(ROTR(bTd(p1), 7))),bTd(sigPadd(ROTR(bTd(p1), 18))))) as Number, bTd(sigPadd(SHR(bTd(p1), 3))))) as String)

fun Sig1(p1) = pad32(dTb(XOR((XOR(bTd(sigPadd(ROTR(bTd(p1), 17))),bTd(sigPadd(ROTR(bTd(p1), 19))))) as Number, bTd(sigPadd(SHR(bTd(p1), 10))))) as String)

fun CSig0(p1) = pad32(dTb(XOR((XOR(bTd(sigPadd(ROTR(bTd(p1), 2))),bTd(sigPadd(ROTR(bTd(p1), 13))))) as Number, bTd(sigPadd(ROTR(bTd(p1), 22))))) as String)

fun CSig1(p1) = pad32(dTb(XOR((XOR(bTd(sigPadd(ROTR(bTd(p1), 6))),bTd(sigPadd(ROTR(bTd(p1), 11))))) as Number, bTd(sigPadd(ROTR(bTd(p1), 25))))) as String)

// This function `SHA256()` is the one which must be used to call and perform the hash operation
fun SHA256(p1) = do {
	
var message = "0" ++ dTb(hTd(sTh(p1))) ++ "1"
var padLen = (a=(ceil(sizeOf(message)/448))) ->  (((512*a) - 64) mod (512*a)) - ((sizeOf(message)))
var padd = rightPad((message),(sizeOf(message) + padLen()) ,0)
var bitPadd = if((sizeOf(dTb(sizeOf(message)-1)) mod 8) != 0) leftPad(dTb(sizeOf(message)-1),((sizeOf(dTb(sizeOf(message)-1)) mod 8) + (8 - (sizeOf(dTb(sizeOf(message)-1)) mod 8))), 0) else dTb(sizeOf(message)-1)
var messageSizeString = leftPad(dTb(sizeOf(message)-1), (sizeOf(bitPadd) + (64 - sizeOf(bitPadd))), 0)
var sizeOfFullString = sizeOf(padd) + sizeOf(messageSizeString)
var fullString = (padd) ++ (messageSizeString)
var Mlist = (fullString splitBy ("") divideBy 512)
var Action16 = (p, s=16) ->  if(s < 64) Action16((p << pad32(dTb(bTd(Sig1(p[s-2])) + bTd((p[s-7])) + bTd(Sig0(p[s-15])) + bTd((p[s-16])) mod pow(2,32)) )),s+1) else p
var Wlist = Mlist map {
 	"M$$": Action16(($ divideBy 32) map ($ joinBy("") ))
		}

fun Venkatesh( MO, a=pad32(dTb(hTd(a))), b=pad32(dTb(hTd(b))), c=pad32(dTb(hTd(c))), d=pad32(dTb(hTd(d))), e=pad32(dTb(hTd(e))), f=pad32(dTb(hTd(f))), g=pad32(dTb(hTd(g))), h=pad32(dTb(hTd(h))), s=0, T1=(((bTd(CSig1(pad32(dTb(hTd(e))))) as Number) + (Ch((hTd(e)),(hTd(f)),(hTd(g))) as Number) + ((hTd(h)) as Number) + ((hTd(K[0])) as Number) + ((bTd(Wlist[0]['M0'][0])) as Number)) mod pow (2,32)), T2=(((bTd(CSig0(pad32(dTb(hTd(a))))) as Number) + (Maj((hTd(a)),(hTd(b)),(hTd(c))) as Number)) mod pow (2,32)), K0=K) = if(s < 64) 
		Venkatesh( MO,

			if(s == 0) ((T1 + T2) mod pow (2,32)) else ((((bTd(CSig1(pad32(dTb(e)))) as Number) + (Ch((e),(f),(g)) as Number) + ((h) as Number) + (hTd(K[s]) as Number) + ((bTd(MO[s])) as Number)) mod pow (2,32)) + ((bTd(CSig0(pad32(dTb(a)))) as Number) + (Maj((a),(b),(c)) as Number) mod pow(2,32)) mod pow(2,32)), 
			
			if(s == 0) bTd(a) else a,
			
			if(s == 0) bTd(b) else b,
			
			if(s == 0) bTd(c) else c,
			
			if(s == 0) (bTd(d) + T1) mod pow(2,32) else ((d) + (((bTd(CSig1(pad32(dTb(e)))) as Number) + (Ch((e),(f),(g)) as Number) + ((h) as Number) + (hTd(K[s]) as Number) + (bTd(MO[s]) as Number)) mod pow (2,32))) mod pow(2,32),
			
			if(s == 0) bTd(e) else e,
			
			if(s == 0) bTd(f) else f,
			
			if(s == 0) bTd(g) else g, 
            
            s+1, 
			
			if(s == 0) T1 else (((bTd(CSig1(pad32(dTb(e)))) as Number) + (Ch((e),(f),(g)) as Number) + ((h) as Number) + (hTd(K[s]) as Number) + (bTd(MO[s]) as Number)) mod pow (2,32)),
			
			if(s == 0) (((bTd(CSig0(a)) as Number) + (Maj(bTd(a),bTd(b),bTd(c)) as Number)) mod pow(2,32)) else ((bTd(CSig0(pad32(dTb(a)))) as Number) + (Maj((a),(b),(c)) as Number) mod pow(2,32))

		) else [(a),(b),(c),(d),(e),(f),(g),(h)]

fun Omkaram (a=(sizeOf(Wlist)-1), b=0, cce=Venkatesh(Wlist[0]['M0']) map (($ + hTd((Initial_V)[$$])) mod pow(2,32))) = 
    	(if(a > 1) "బహుళ సందేశ బ్లాక్‌ల కోసం కోడ్ సంక్లిష్టతను డీబగ్ చేయడం చాలా కష్టంగా మారుతోంది. 440 బిట్స్ కంటే ఎక్కువ సందేశ ఇన్‌పుట్‌లను నిర్వహించడానికి నేను కోడ్ వ్రాయలేదు. కాబట్టి దయచేసి, మీ ఇన్‌పుట్ స్ట్రింగ్‌ను పేర్కొన్న పరిమితిలో పరిమితం చేయండి. నేను ఖాళీగా ఉన్నప్పుడు ఏదో ఒకరోజు ఈ కోడ్‌ని అప్‌డేట్ చేస్తాను." else cce)
				// Translation to the above text, "Debugging code complexity for multiple message blocks is becoming difficult. I did not write code to handle message inputs larger than 440 bits. If you pass more than 55 bytes, this code will give incorrect results. So, please limit your input string to the specified limit."
---

lower(Omkaram() map (bThex(dTb($))) joinBy(""))

}