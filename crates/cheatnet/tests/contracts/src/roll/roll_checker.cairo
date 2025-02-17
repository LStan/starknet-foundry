#[starknet::interface]
trait IRollChecker<TContractState> {
    fn get_block_number(ref self: TContractState) -> u64;
    fn get_block_number_and_emit_event(ref self: TContractState) -> u64;
}

#[starknet::contract]
mod RollChecker {
    use box::BoxTrait;
    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        BlockNumberEmitted: BlockNumberEmitted
    }

    #[derive(Drop, starknet::Event)]
    struct BlockNumberEmitted {
        block_number: u64
    }

    #[external(v0)]
    impl IRollChecker of super::IRollChecker<ContractState> {
        fn get_block_number(ref self: ContractState) -> u64 {
            starknet::get_block_info().unbox().block_number
        }

        fn get_block_number_and_emit_event(ref self: ContractState) -> u64 {
            let block_number = starknet::get_block_info().unbox().block_number;
            self.emit(Event::BlockNumberEmitted(BlockNumberEmitted { block_number }));
            block_number
        }
    }
}
