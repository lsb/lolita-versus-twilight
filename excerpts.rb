Lolita = File.read("lolita.txt", :encoding => "UTF-8").gsub(/\r\n/,"\n").gsub(/ +/,' ')
Lolita_paras = Lolita.split(/\n (?=[[:alpha:]])/)
Lolita_excerpts = (0...Lolita_paras.size).map {|i| Lolita_paras[i,2].join("\n ") }
Twilight = File.read("twilight.txt", :encoding => "UTF-8").tr("\r=","")
Twilight_paras = Twilight.split(/\n{2,}/)
Twilight_excerpts = (0...Twilight_paras.size./(6)).map {|i| Twilight_paras[i*6,12].join("\n\n") }
GSTT = File.read("gstt.json", :encoding => "UTF-8")
Delineate = lambda {|excerpt| "----------\n" + excerpt + "\n----------\n\n" }
Excerpts = (Lolita_excerpts + Twilight_excerpts).map(&Delineate)


Instructions = "Please read the following pairs of literature excerpts and choose which excerpt you prefer."
Question = "Which do you prefer?"
Extras = {samples: 3, gs_failure_rate: 0, nonce: "xmaseve"}

require './comparison-networks'
require './ask-a-human'

GoldStandards = JSON.parse(GSTT).map {|good,bad| [Question, good, bad] }

def compare_excerpts(t1, t2)
  ask_human_choose_one(Instructions, Question, [t1, t2], GoldStandards, Extras)
end


### Hash[JSON.parse(GSTT).pmap {|pair| good, bad = *pair.map(&Delineate) ; [pair.first[0,50], ask_human_choose_one(Instructions, Question, [good,bad], [], {samples: 100}).count(good)] }]
###  => {"If one day it happens you find yourself with someo"=>74, "We have noticed in nature that the behavior of a f"=>65, "The head of a pin is a sixteenth of an inch across"=>65, "Atoms on a small scale behave like nothing on a la"=>64, "These are the first days of fall. The wind\nat even"=>70, "After he finished the blackjack program and got it"=>56, "If personality is an unbroken series of successful"=>59}

### 
