//
// Created by Mengyu Li on 2021/1/12.
//

extension Cursor {
    enum Operation {
        case first				/** Position at first key/data item */
        case firstDup			/** Position at first data item of current key.Only for #MDB_DUPSORT */
        case getBoth			/** Position at key/data pair. Only for #MDB_DUPSORT */
        case getBothRange		/** position at key, nearest data. Only for #MDB_DUPSORT */
        case getCurrent		    /** Return key/data at current cursor position */
        case getMultiple		/** Return up to a page of duplicate data items from current cursor position. Move cursor to prepare for #MDB_NEXT_MULTIPLE. Only for #MDB_DUPFIXED */
        case last				/** Position at last key/data item */
        case lastDup			/** Position at last data item of current key.Only for #MDB_DUPSORT */
        case next				/** Position at next data item */
        case nextDup			/** Position at next data item of current key.Only for #MDB_DUPSORT */
        case nextMultiple		/** Return up to a page of duplicate data items from next cursor position. Move cursor to prepare for #MDB_NEXT_MULTIPLE. Only for #MDB_DUPFIXED */
        case nextNodup			/** Position at first data item of next key */
        case prev				/** Position at previous data item */
        case prevDup			/** Position at previous data item of current key.Only for #MDB_DUPSORT */
        case prevNodup			/** Position at last data item of previous key */
        case set				/** Position at specified key */
        case setKey			    /** Position at specified key, return key + data */
        case setRange			/** Position at first key greater than or equal to specified key. */
        case prevMultiple		/** Position at previous page and return up to a page of duplicate data items. Only for #MDB_DUPFIXED */
    }
}
