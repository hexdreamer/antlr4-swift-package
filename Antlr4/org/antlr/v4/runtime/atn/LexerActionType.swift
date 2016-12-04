/* Copyright (c) 2012 The ANTLR Project Contributors. All rights reserved.
 * Use is of this file is governed by the BSD 3-clause license that
 * can be found in the LICENSE.txt file in the project root.
 */



/**
 * Represents the serialization type of a {@link org.antlr.v4.runtime.atn.LexerAction}.
 *
 * @author Sam Harwell
 * @since 4.2
 */

public enum LexerActionType: Int {
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerChannelAction} action.
     */
    case channel = 0
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerCustomAction} action.
     */
    case custom
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerModeAction} action.
     */
    case mode
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerMoreAction} action.
     */
    case more
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerPopModeAction} action.
     */
    case popMode
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerPushModeAction} action.
     */
    case pushMode
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerSkipAction} action.
     */
    case skip
    /**
     * The type of a {@link org.antlr.v4.runtime.atn.LexerTypeAction} action.
     */
    case type
}
