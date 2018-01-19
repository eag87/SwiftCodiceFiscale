//
//  Function.swift
//  Sondaggi
//
//  Created by Enrico-Andrea Gioacchini on 19/01/18.
//  Copyright © 2018 Enrico-Andrea Gioacchini. All rights reserved.
//

import Foundation

//definisco regex
let alphanumericRegex = "([A-Z0-9])"
let textRegex = "([A-Z])"
let numericRegex = "([0-9])"
let codmesi = "([ABCDEHLMPRST])"

//definisco delle variabili globali in cui salverò i valori ricavati
var meseNascita = 1
var annoNascita = 1900
var giornoNascita = 0
var sesso = "Nan"
//codifica dei mesi
let arrayMesi = ["A":1,"B":2,"C":3,"D":4,"E":5,"H":6,"L":7,"M":8,"P":9,"R":10,"S":11,"T":12]

//funzione per verificare che il valore passato sia un codice fiscale
func checkCF(cf : String) -> Bool{
//variabii temporanee utili al calcolo delle variabili globali dei risultati
    var annoTemp = ""
    var giornoTemp = ""
     var indice = 1
//re-inizializzo le variabili in tal modo se viene effettuata nuovamente la chiamata queste sono resettate
     meseNascita = 1
     annoNascita = 1900
     giornoNascita = 0
     sesso = "Nan"
    
        let cfAlphanumerico = matches(for: alphanumericRegex, in: cf)
        //ottengo un array alfanumerico con tutti i caratteri validati nel regex, se sono 16 allora sono tutti validati
        if (!(cfAlphanumerico.count == 16)){
            return false
        }
        //ciclo per tutti e 16 i caratteri suddivisi per la loro posizione, se una sola condizione non è valida torno con un FALSE
        for c in cfAlphanumerico{
            
            switch(indice){
            case 1,2,3,4,5,6,12,16:
                if(checkString(str: c)){
                    //print("controllo se i primi 6, 12 e 16 sono stringhe pos= \(indice)")
                }else{
                    return false
                }
                break
            case 7,8:
                //anno di nascita
                
                if(checkInt(str: c)){
                    //print("controllo se posizione 7 e 8 sono interi pos= \(indice)")
                    annoTemp+=c
                    if(annoTemp.count == 2){
                        getAnno(anno: annoTemp)
                    }
                }else{
                    return false
                }
                break
            case 9:
                //mese
                if(checkString(str: c)){
                    //print("controllo se la posizione 9 e' stringa pos= \(indice)")
                    //controllo che il valore del mese sia presente nella codifica
                    let checkMese = matches(for: codmesi, in: c)
                    if(checkMese.count > 0){
                        meseNascita = arrayMesi[c]!
                    }else{
                        return false
                    }
                }else{
                    return false
                }
                break
            case 10,11:
                //giorno di nascita, se maggiore di 40 femmina
                if(checkInt(str: c)){
                    //print("controllo se posizione 10 e 11 sono interi pos= \(indice)")
                    giornoTemp+=c
                    if(giornoTemp.count == 2){
                        getGiorno(giorno: giornoTemp)
                    }
                }else{
                    return false
                }
                break
            case 13,14,15:
                //giorno di nascita, se maggiore di 40 femmina
                if(checkInt(str: c)){
                    //print("controllo se posizione 13 14 e 15 sono interi pos= \(indice)")
                }else{
                    return false
                }
                break
            default:
                return false
            }
          indice += 1
        }
    
    return true
}
//funzione per il regex, ritorna un array con tutti i valori presenti nel regex passato, altrimenti un array vuoto
func matches(for regex: String, in text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}
//controllo una stringa nel regex degli interi 0-9
func checkInt(str : String) -> Bool{
    let check = matches(for: numericRegex, in: str)
    if(check.count == 0){
        print("vuoto, quindi non un numero")
        return false
    }else{
        //print("numero check= \(check)")
        return true
    }
}
//controllo una stringa nel regex delle stringhe A-Z
func checkString(str : String) -> Bool{
    let check = matches(for: textRegex, in: str)
    if(check.count == 0){
        print("vuoto, quindi non un string")
        return false
    }else{
        //print("string check= \(check)")
        return true
    }
}
func getAnno(anno: String){
    let age = Int(anno)!
    annoNascita = annoNascita + age
}
func getGiorno(giorno: String){
    let gg = Int(giorno)!
    giornoNascita = giornoNascita + gg
    //controllo se maggiore di 40 allora sesso femminile
    if (giornoNascita > 40){
        sesso = "F"
        giornoNascita = giornoNascita - 40
    }else{
        sesso = "M"
    }
}
