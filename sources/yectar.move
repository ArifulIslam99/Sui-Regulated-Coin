module regulated_coin::yectar{
    use sui::coin::{Self, TreasuryCap, Coin, DenyCap};
    use sui::url;
    use std::ascii;
    use sui::deny_list::{Self, DenyList};
    use sui::balance;
    public struct YECTAR has drop {}

    public struct TreasuryCapHolder has key {
        id: UID,
        treasury_cap: TreasuryCap<YECTAR>
    }

    const EInsufficientFunds: u64 = 1001;

    fun init (otw: YECTAR, ctx: &mut TxContext) {
        let (treasury_cap, deny_cap, metadata) = coin::create_regulated_currency(
            otw,
            9,
            b"YTR",
            b"YecTar",
            b"YecTar Creates Journey!",
            option::some(url::new_unsafe(ascii::string(b"https://i.ibb.co/stR07Dy/coin.jpg"))),
            ctx
        );

        let mut treasury_cap_holder = TreasuryCapHolder {
            id: object::new(ctx),
            treasury_cap,
        };
        let supply_amount: u64 = 1000000000000000000;
        coin::mint_and_transfer(&mut treasury_cap_holder.treasury_cap, supply_amount, tx_context::sender(ctx), ctx);
        transfer::public_transfer(metadata,  tx_context::sender(ctx));
        transfer::transfer(treasury_cap_holder,  tx_context::sender(ctx));
        transfer::public_transfer(deny_cap,  tx_context::sender(ctx));
    }

    public entry fun conditional_transfer(
        deny_cap: &mut DenyCap<YECTAR>,
        deny_list: &mut DenyList,
        recipient: address,
        amount: u64,
        coin_id: &mut Coin<YECTAR>,
        ctx: &mut TxContext
        ) {
            assert!(coin::value(coin_id) >= amount, EInsufficientFunds);
            let coin_balance = coin::balance_mut(coin_id);
            let transfer_amount = balance::split(coin_balance, amount);
            transfer::public_transfer(coin::from_balance(transfer_amount, ctx), recipient);
            coin::deny_list_add<YECTAR>(
                deny_list,
                deny_cap,
                recipient,
                ctx
            );
    }
    
}