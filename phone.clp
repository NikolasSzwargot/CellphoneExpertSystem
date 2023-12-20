
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     For use with the Auto Demo Example
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule what-is-your-kid ""

   (logical (start))

   =>

   (assert (UI-state (display StartQuestion)
                     (relation-asserted your-kid-is)
                     (response Start1Answer)
                     (valid-answers Start1Answer Start2Answer Start3Answer Start4Answer))))
   
(defrule determine-whining ""

   (logical (your-kid-is Start1Answer))

   =>

   (assert (UI-state (display WhiningQuestion)
                     (relation-asserted whining-is)
                     (response Whining1Answer)
                     (valid-answers Whining1Answer Whining2Answer Whining3Answer))))

(defrule determine-never-looks-up ""

   (logical (your-kid-is Start2Answer))

   =>

   (assert (UI-state (display NeverLooksUpQuestion)
                     (relation-asserted never-looks-up-is)
                     (response NeverLooksUp1Answer)
                     (valid-answers NeverLooksUp1Answer NeverLooksUp2Answer))))

(defrule determine-smashed-phone ""

   (logical (your-kid-is Start3Answer))

   =>

   (assert (UI-state (display SmashedPhoneQuestion)
                     (relation-asserted smashed-phone-is)
                     (response SmashedPhone1Answer)
                     (valid-answers SmashedPhone1Answer SmashedPhone2Answer SmashedPhone3Answer))))

(defrule determine-just-one ""

   (logical (your-kid-is Start4Answer))

   =>

   (assert (UI-state (display JustOneQuestion)
                     (relation-asserted just-one-is)
                     (response JustOneAnswer)
                     (valid-answers JustOneAnswer))))
   
(defrule determine-bullying ""

   (logical (whining-is Whining1Answer))

   =>

   (assert (UI-state (display BullyingQuestion)
                     (relation-asserted bullying-is)
                     (response BullyingAnswer)
                     (valid-answers BullyingAnswer))))

(defrule determine-bankrolling ""

   (logical (whining-is Whining3Answer))

   =>

   (assert (UI-state (display BankrollingQuestion)
                     (relation-asserted bankrolling-is)
                     (response Bankrolling1Answer)
                     (valid-answers Bankrolling1Answer Bankrolling2Answer Bankrolling3Answer))))

(defrule determine-rules ""

   (or (logical (never-looks-up-is NeverLooksUp1Answer))
   (logical (urgent-calls-is UrgentCalls2Answer)))

   =>

   (assert (UI-state (display RulesQuestion)
                     (relation-asserted rules-is)
                     (response Rules1Answer)
                     (valid-answers Rules1Answer Rules2Answer))))

(defrule determine-losing-phone ""

   (or (logical (never-looks-up-is NeverLooksUp2Answer))
   (logical (urgent-calls-is UrgentCalls1Answer)))

   =>

   (assert (UI-state (display LosingPhoneQuestion)
                     (relation-asserted losing-phone-is)
                     (response LosingPhone1Answer)
                     (valid-answers LosingPhone1Answer LosingPhone2Answer))))

(defrule determine-another-phone ""

   (or (logical (smashed-phone-is SmashedPhone1Answer))
   (logical (smashed-phone-is SmashedPhone2Answer))
   (logical (smashed-phone-is SmashedPhone3Answer))
   (logical (lost-phone-is LostPhone1Answer))
   (logical (lost-phone-is LostPhone2Answer)))

   =>

   (assert (UI-state (display AnotherPhoneQuestion)
                     (relation-asserted another-phone-is)
                     (response AnotherPhone1Answer)
                     (valid-answers AnotherPhone1Answer AnotherPhone2Answer Charges2Answer))))

(defrule determine-wants-new ""

   (logical (just-one-is JustOneAnswer))

   =>

   (assert (UI-state (display WantsNewQuestion)
                     (relation-asserted wants-new-is)
                     (response WantsNew1Answer)
                     (valid-answers WantsNew1Answer Charges2Answer))))

(defrule determine-bullied-now ""

   (logical (bullying-is BullyingAnswer))

   =>

   (assert (UI-state (display BulliedNowQuestion)
                     (relation-asserted bullied-now-is)
                     (response BulliedNow1Answer)
                     (valid-answers BulliedNow1Answer BulliedNow2Answer))))

(defrule determine-charges ""

   (or (logical (bankrolling-is Bankrolling1Answer))
   (logical (bankrolling-is Bankrolling2Answer)))

   =>

   (assert (UI-state (display ChargesQuestion)
                     (relation-asserted charges-is)
                     (response Charges1Answer)
                     (valid-answers Charges1Answer Charges2Answer))))

(defrule determine-urgent-calls ""

   (logical (rules-is Rules1Answer))

   =>

   (assert (UI-state (display UrgentCallsQuestion)
                     (relation-asserted urgent-calls-is)
                     (response UrgentCalls1Answer)
                     (valid-answers UrgentCalls1Answer UrgentCalls2Answer))))

(defrule determine-human-child ""

   (or (logical (rules-is Rules2Answer))
   (logical (charges-is Charges1Answer)))

   =>

   (assert (UI-state (display HumanChildQuestion)
                     (relation-asserted human-child-is)
                     (response HumanChild1Answer)
                     (valid-answers HumanChild1Answer))))

(defrule determine-lost-phone ""

   (or (logical (losing-phone-is LosingPhone1Answer))
   (logical (losing-phone-is LosingPhone2Answer)))

   =>

   (assert (UI-state (display LostPhoneQuestion)
                     (relation-asserted lost-phone-is)
                     (response LostPhone1Answer)
                     (valid-answers LostPhone1Answer LosLostPhone2AnsweringPhone2Answer))))

(defrule determine-apple-care ""

   (or (logical (another-phone-is AnotherPhone1Answer))
   (logical (wants-new-is WantsNew1Answer)))

   =>

   (assert (UI-state (display AppleCareQuestion)
                     (relation-asserted apple-care-is)
                     (response AppleCare1Answer)
                     (valid-answers AppleCare1Answer Charges2Answer))))

(defrule determine-puppy ""

   (logical (bullied-now-is BulliedNow1Answer))

   =>

   (assert (UI-state (display PuppyQuestion)
                     (relation-asserted puppy-is)
                     (response Puppy1Answer)
                     (valid-answers Puppy1Answer Puppy2Answer))))

(defrule determine-leverage ""

   (or (logical (bullied-now-is BulliedNow2Answer))
   (logical (puppy-is Puppy1Answer)))

   =>

   (assert (UI-state (display LeverageQuestion)
                     (relation-asserted leverage-is)
                     (response Leverage1Answer)
                     (valid-answers Leverage1Answer))))



;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule dont-get-phone-conclusions ""

   (or (logical (whining-is Whining2Answer))
   (logical (apple-care-is AppleCare1Answer))
   
   =>

   (assert (UI-state (display DontGetPhone)
                     (state final))))

(defrule why-you-asking-conclusions ""

    (or (logical (bankrolling-is Bankrolling3Answer))
    (logical (another-phone-is AnotherPhone2Answer))
    (logical (puppy-is Puppy2Answer)))

   =>

   (assert (UI-state (display WhyYouAsking)
                     (state final))))

(defrule get-phone-conclusions ""

    (or (logical (another-phone-is Charges2Answer))
    (logical (charges-is Charges2Answer))
    (logical (wants-new-is Charges2Answer))
    (logical (leverage-is Leverage1Answer)))

   =>

   (assert (UI-state (display GetPhone)
                     (state final))))

(defrule buy-kevin-phone-conclusions ""

    (logical (human-child-is HumanChild1Answer))

   =>

   (assert (UI-state (display BuyKevinPhone)
                     (state final))))

;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
