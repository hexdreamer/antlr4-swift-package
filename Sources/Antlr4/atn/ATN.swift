/// 
/// Copyright (c) 2012-2017 The ANTLR Project. All rights reserved.
/// Use of this file is governed by the BSD 3-clause license that
/// can be found in the LICENSE.txt file in the project root.
/// 


public class ATN {
    public static let INVALID_ALT_NUMBER: Int = 0


    public final var states: Array<ATNState?> = Array<ATNState?>()

    /// 
    /// Each subrule/rule is a decision point and we must track them so we
    /// can go back later and build DFA predictors for them.  This includes
    /// all the rules, subrules, optional blocks, ()+, ()* etc...
    /// 
    public final var decisionToState: Array<DecisionState> = Array<DecisionState>()

    /// 
    /// Maps from rule index to starting state number.
    /// 
    public final var ruleToStartState: [RuleStartState]!

    /// 
    /// Maps from rule index to stop state number.
    /// 
    public final var ruleToStopState: [RuleStopState]!


    public final let modeNameToStartState: Dictionary<String, TokensStartState> =  Dictionary<String, TokensStartState>()
    //LinkedHashMap<String, TokensStartState>();

    /// 
    /// The type of the ATN.
    /// 
    public  let grammarType: ATNType!

    /// 
    /// The maximum value for any symbol recognized by a transition in the ATN.
    /// 
    public  let maxTokenType: Int

    /// 
    /// For lexer ATNs, this maps the rule index to the resulting token type.
    /// For parser ATNs, this maps the rule index to the generated bypass token
    /// type if the
    /// _org.antlr.v4.runtime.atn.ATNDeserializationOptions#isGenerateRuleBypassTransitions_
    /// deserialization option was specified; otherwise, this is `null`.
    /// 
    public final var ruleToTokenType: [Int]!

    /// 
    /// For lexer ATNs, this is an array of _org.antlr.v4.runtime.atn.LexerAction_ objects which may
    /// be referenced by action transitions in the ATN.
    /// 
    public final var lexerActions: [LexerAction]!

    public final  var modeToStartState: Array<TokensStartState> = Array<TokensStartState>()

    /// 
    /// Used for runtime deserialization of ATNs from strings
    /// 
    public init(_ grammarType: ATNType, _ maxTokenType: Int) {
        self.grammarType = grammarType
        self.maxTokenType = maxTokenType
    }

    /// 
    /// Compute the set of valid tokens that can occur starting in state `s`.
    /// If `ctx` is null, the set of tokens will not include what can follow
    /// the rule surrounding `s`. In other words, the set will be
    /// restricted to tokens reachable staying within `s`'s rule.
    /// 
    public func nextTokens(_ s: ATNState, _ ctx: RuleContext?) -> IntervalSet {
        let anal = LL1Analyzer(self)
        let next = anal.LOOK(s, ctx)
        return next
    }

    /// 
    /// Compute the set of valid tokens that can occur starting in `s` and
    /// staying in same rule. _org.antlr.v4.runtime.Token#EPSILON_ is in set if we reach end of
    /// rule.
    /// 
    public func nextTokens(_ s: ATNState) -> IntervalSet {
        if let nextTokenWithinRule = s.nextTokenWithinRule {
            return nextTokenWithinRule
        }
        let intervalSet = nextTokens(s, nil)
        s.nextTokenWithinRule = intervalSet
        intervalSet.makeReadonly()
        return intervalSet
    }

    public func addState(_ state: ATNState?) {
        if let state = state {
            state.atn = self
            state.stateNumber = states.count
        }

        states.append(state)
    }

    public func removeState(_ state: ATNState) {
        states[state.stateNumber] = nil
        //states.set(state.stateNumber, nil); // just free mem, don't shift states in list
    }
    @discardableResult
    public func defineDecisionState(_ s: DecisionState) -> Int {
        decisionToState.append(s)
        s.decision = decisionToState.count-1
        return s.decision
    }

    public func getDecisionState(_ decision: Int) -> DecisionState? {
        if  !decisionToState.isEmpty  {
            return decisionToState[decision]
        }
        return nil
    }

    public func getNumberOfDecisions() -> Int {
        return decisionToState.count
    }

    /// 
    /// Computes the set of input symbols which could follow ATN state number
    /// `stateNumber` in the specified full `context`. This method
    /// considers the complete parser context, but does not evaluate semantic
    /// predicates (i.e. all predicates encountered during the calculation are
    /// assumed true). If a path in the ATN exists from the starting state to the
    /// _org.antlr.v4.runtime.atn.RuleStopState_ of the outermost context without matching any
    /// symbols, _org.antlr.v4.runtime.Token#EOF_ is added to the returned set.
    /// 
    /// If `context` is `null`, it is treated as
    /// _org.antlr.v4.runtime.ParserRuleContext#EMPTY_.
    /// 
    /// - parameter stateNumber: the ATN state number
    /// - parameter context: the full parse context
    /// - returns: The set of potentially valid input symbols which could follow the
    /// specified state in the specified context.
    /// - throws: _ANTLRError.illegalArgument_ if the ATN does not contain a state with
    /// number `stateNumber`
    /// 
    public func getExpectedTokens(_ stateNumber: Int, _ context: RuleContext) throws -> IntervalSet {
        if stateNumber < 0 || stateNumber >= states.count {
            throw ANTLRError.illegalArgument(msg: "Invalid state number.")
        }

        var ctx: RuleContext? = context
        let s = states[stateNumber]!
        var following = nextTokens(s)
        if !following.contains(CommonToken.EPSILON) {
            return following
        }

        let expected = IntervalSet()
        try! expected.addAll(following)
        try! expected.remove(CommonToken.EPSILON)

        while let ctxWrap = ctx, ctxWrap.invokingState >= 0 && following.contains(CommonToken.EPSILON) {
            let invokingState = states[ctxWrap.invokingState]!
            let rt = invokingState.transition(0) as! RuleTransition
            following = nextTokens(rt.followState)
            try! expected.addAll(following)
            try! expected.remove(CommonToken.EPSILON)
            ctx = ctxWrap.parent
        }

        if following.contains(CommonToken.EPSILON) {
            try! expected.add(CommonToken.EOF)
        }

        return expected
    }

    public final func appendDecisionToState(_ state: DecisionState) {
        decisionToState.append(state)
    }
    public final func appendModeToStartState(_ state: TokensStartState) {
        modeToStartState.append(state)
    }


}
