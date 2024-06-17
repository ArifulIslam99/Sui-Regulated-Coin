module regulated_coin::yectar{
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::option;
    use sui::object::{Self, UID};
    use sui::url;
    use std::ascii;

    public struct YECTAR has drop {}
}