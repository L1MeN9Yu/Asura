// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Asura",
    products: [
        .library(name: "LMDB", targets: ["LMDB"]),
    ],
    targets: [
        .target(name: "CLMDB"),
        .target(name: "LMDB", dependencies: ["CLMDB"]),
        .testTarget(name: "LMDBTest", dependencies: ["LMDB"]),

        .target(name: "CLevelDB", exclude: [
            "db/leveldbutil.cc",
            "util/env_windows.cc",
            "util/testutil.cc",
            "db/autocompact_test.cc",
            "db/corruption_test.cc",
            "db/db_test.cc",
            "db/dbformat_test.cc",
            "db/fault_injection_test.cc",
            "db/filename_test.cc",
            "db/log_test.cc",
            "db/recovery_test.cc",
            "db/skiplist_test.cc",
            "db/version_edit_test.cc",
            "db/version_set_test.cc",
            "db/write_batch_test.cc",
            "issues/issue178_test.cc",
            "issues/issue200_test.cc",
            "issues/issue320_test.cc",
            "table/filter_block_test.cc",
            "table/table_test.cc",
            "util/arena_test.cc",
            "util/bloom_test.cc",
            "util/cache_test.cc",
            "util/coding_test.cc",
            "util/crc32c_test.cc",
            "util/env_posix_test.cc",
            "util/env_test.cc",
            "util/env_windows_test.cc",
            "util/hash_test.cc",
            "util/logging_test.cc",
            "util/no_destructor_test.cc",
            "util/status_test.cc",
            "db/c_test.c",
            "port/port_config.h.in",
            "port/README.md",
        ], sources: [
            "db/",
            "port/",
            "table/",
            "util/",
            "include/",
        ], publicHeadersPath: "header", cSettings: [
            .define("LEVELDB_IS_BIG_ENDIAN", to: "0"),
            .define("LEVELDB_PLATFORM_POSIX", to: "1"),
            .define("HAVE_FULLFSYNC", to: "1"),
            .headerSearchPath("./"),
            .headerSearchPath("include/"),
        ]),
        .target(name: "LevelDB", dependencies: ["CLevelDB"]),
        .testTarget(name: "LevelDBTests", dependencies: ["LevelDB"])
    ],
    cLanguageStandard: CLanguageStandard.c11,
    cxxLanguageStandard: CXXLanguageStandard.gnucxx14
)
