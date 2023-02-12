/**
 * 参加するキャラクターID配列を返却する
 * @return {Array} キャラクターID配列 
 */
function getParticipantsIdList () {
  // 呼び出し元が何も考えず呼び出せるよう、引数はとらない方針
  // この中で、ゲーム変数を読み込んだりロジックを書くなどして返却値を決めること
  let participantsIdList = [
    CHARACTER_ID_ZUNDAMON,
    CHARACTER_ID_METAN,
    CHARACTER_ID_TSUMUGI,
    CHARACTER_ID_HAU,
    CHARACTER_ID_RITSU,
  ];
  // let participantsIdList = [
  //   CHARACTER_ID_AI,
  //   CHARACTER_ID_HIYORI,
  //   CHARACTER_ID_FUTABA,
  //   CHARACTER_ID_MIKI,
  //   CHARACTER_ID_DUMMY,
  // ];
  return participantsIdList;
}


/**
 * 配役される役職ID配列を返却する
 * @return {Array} 役職ID配列 
 */
function getVillagersRoleIdList() {
  // 呼び出し元が何も考えず呼び出せるよう、引数はとらない方針
  // この中で、ゲーム変数を読み込んだりロジックを書くなどして返却値を決めること

  let villagersRoleIdList = [
    ROLE_ID_FORTUNE_TELLER,
    ROLE_ID_VILLAGER,
    ROLE_ID_MADMAN,
    ROLE_ID_WEREWOLF,
    ROLE_ID_VILLAGER,
  ];

  // シャッフルしてから返却する
  if (TYRANO.kag.stat.f.developmentMode) {
    // TODO テスト用にそのまま返却
    return villagersRoleIdList;
  }
  return shuffleElements(villagersRoleIdList);

}


/**
 * ダステンフェルドの手法で、配列の要素をランダムな順番にシャッフルする
 * 引用：{@link https://qiita.com/pure-adachi/items/77fdf665ff6e5ea22128}
 * @param {Array} targetArray シャッフル対象の配列
 * @return {Array} シャッフル後の配列
 */
function shuffleElements(targetArray) {
  for (i = targetArray.length; 1 < i; i--) {
    k = Math.floor(Math.random() * i);
    [targetArray[k], targetArray[i - 1]] = [targetArray[i - 1], targetArray[k]];
  }
  return targetArray;
}


/**
 * キャラクターIDからキャラクターデータオブジェクトを生成し、返却する
 * @param {String} characterId キャラクターID
 * @return {Object} キャラクターデータオブジェクト
 */
function createCharacterData(characterId) {
  switch (characterId) {
    case CHARACTER_ID_AI:
      return new AiData();
    case CHARACTER_ID_HIYORI:
      return new HiyoriData();
    case CHARACTER_ID_FUTABA:
      return new FutabaData();
    case CHARACTER_ID_MIKI:
      return new MikiData();
    case CHARACTER_ID_ZUNDAMON:
      return new ZundamonData();
    case CHARACTER_ID_METAN:
      return new MetanData();
    case CHARACTER_ID_TSUMUGI:
      return new TsumugiData();
    case CHARACTER_ID_HAU:
      return new HauData();
    case CHARACTER_ID_RITSU:
      return new RitsuData();
    case CHARACTER_ID_YU:
    default:
      return new DummyData();
  }
}


/**
 * 役職IDから役職オブジェクトを生成し、返却する
 * @param {String} roleId 役職ID
 */
function roleAssignment(roleId) {
  switch (roleId) {
    case ROLE_ID_VILLAGER: // 村人
      return new Villager();
    case ROLE_ID_WEREWOLF: // 人狼
      return new Werewolf();
    case ROLE_ID_FORTUNE_TELLER: // 占い師
      return new FortuneTeller();
    case ROLE_ID_MADMAN: // 狂人
      return new Madman();
    case ROLE_ID_PHYCHIC: // 霊媒師（未実装）
    case ROLE_ID_HUNTER:  // 狩人（未実装）
    case ROLE_ID_FOX:  // 妖狐（未実装）
    default:
      break;
  }
}


/**
 * 勝利陣営がいるかを判定する
 * TODO 第三陣営（妖狐など）には対応できていないため、実装するなら、呼び先メソッドや各役職クラスのフィールドなどを修正すること
 * @param {Array} characterObjects キャラクターオブジェクトの配列
 * @return {String|null} 勝利した陣営の定数　いなければnull
 */
function judgeWinnerCamp(characterObjects) {
  // 生存者のオブジェクトを取得する
  const survivorObjects = getSurvivorObjects(characterObjects);

  // 勝利陣営判定を行う
  let winnerCamp = null;
  if (isWinWerewolves(survivorObjects)) {
    // 人狼陣営が勝利条件を満たした場合
    winnerCamp = CAMP_WEREWOLVES;
  } else if (isWinVillagers(survivorObjects)) {
    // 村人陣営が勝利条件を満たした場合
    winnerCamp = CAMP_VILLAGERS;
  }
  return winnerCamp;
}


/**
 * 「生存者か」プロパティをもとに、該当するキャラクターオブジェクトだけを返却する
 * @param {Array} characterObjects キャラクターオブジェクトの配列
 * @param {Boolean} [searchFlg=true] 検索値 true（デフォルト）:生存者 false:死亡済み
 * @return {Array} 検索値に適合したキャラクターオブジェクトの配列
 */
function getSurvivorObjects(characterObjects, searchFlg = true) {
  const resultObjects = [];
  for (let k of Object.keys(characterObjects)) {
    if (characterObjects[k].isAlive == searchFlg) {
      resultObjects.push(characterObjects[k]);
    }
  }
  return resultObjects;
}


/**
 * 「人狼陣営か」プロパティをもとに、該当するキャラクターオブジェクトだけを返却する
 * @param {Array} characterObjects キャラクターオブジェクトの配列
 * @param {Boolean} [searchFlg=true] 検索値 true（デフォルト）:人狼陣営 false:人狼陣営ではない
 * @return {Array} 検索値に適合したキャラクターオブジェクトの配列
 */
function getIsWerewolvesObjects(characterObjects, searchFlg = true) {
  const resultObjects = [];
  for (let k of Object.keys(characterObjects)) {
    if (characterObjects[k].role.isWerewolves == searchFlg) {
      resultObjects.push(characterObjects[k]);
    }
  }
  return resultObjects;
}


/**
 * 人狼陣営の勝利判定を行う
 * @param {Array} survivorObjects 生存者のキャラクターオブジェクト配列
 * @return {Boolean} true:勝利 false:勝利ではない
 */
function isWinWerewolves(survivorObjects) {
  // 人狼が、生存者数の半数以上であれば、人狼陣営の勝利
  const survivorsCount = survivorObjects.length;
  const werewolvesCount = getIsWerewolvesObjects(survivorObjects).length;
  if (TYRANO.kag.stat.f.developmentMode) {
    console.log('生存者数:' + survivorsCount + '名 うち人狼の数:' + werewolvesCount + '名');
    alert('生存者数:' + survivorsCount + '名 うち人狼の数:' + werewolvesCount + '名');
  }
  return werewolvesCount >= Math.ceil(survivorsCount / 2);
}


/**
 * 村人陣営の勝利判定を行う
 * @param {Array} survivorObjects 生存者のキャラクターオブジェクト配列
 * @return {Boolean} true:勝利 false:勝利ではない
 */
function isWinVillagers(survivorObjects) {
  // 人狼が0人であれば、村人陣営の勝利
  return getIsWerewolvesObjects(survivorObjects).length == 0;
}


/**
 * キャラクターの死亡処理および死亡回避処理を行う
 * TODO 役職が増えて死亡契機や死亡回避ケースが増えた場合、修正する（ex:狩人の護衛による失敗、妖狐への襲撃による失敗、妖狐への占いによる死亡）
 * @param {Object} characterObject 死亡処理対象のキャラクターオブジェクト
 * @param {String} causeOfDeath 死因定数
 * @return {Boolean} 死亡成功判定 TODO 死亡判定メッセージも返すようにする？
 */
function causeDeathToCharacter(characterObject, causeOfDeath) {
  let isDead = false;
  if (causeOfDeath == DEATH_BY_EXECUTION) {
    // 投票による処刑
    isDead = true;
    characterObject.isAlive = false;
    //console.log(characterObject.name + '（' + characterObject.role.roleName + '）は投票の結果処刑された……');
  } else if (causeOfDeath == DEATH_BY_ATTACK) {
    // 人狼による襲撃
    isDead = true;
    characterObject.isAlive = false;
    //console.log(characterObject.name + '（' + characterObject.role.roleName + '）は人狼の襲撃の犠牲となった……');
  } else {
    // 未定義の死因は、死ななかった判定にしておく
    //console.log(characterObject.name + '（' + characterObject.role.roleName + '）は何故か死ななかった！');
  }
  return isDead;
}


/**
 * 渡された配列からランダムな1要素を取り出して返却する。
 * @param {Array} targetArray 
 * @return {*} 配列の1要素
 */
function getRandomElement(targetArray) {
  return targetArray[Math.floor(Math.random() * targetArray.length)];
}


/**
 * targetArrayから、removalsにある要素を除外した配列を返却する
 * @param {Array} targetArray 対象の配列
 * @param {Array} removals 除外する要素を指定した配列。1要素でも配列型にすること。
 * @return {Array} targetArrayから、removalsにある要素を除外した配列
 */
function getRemovedArray(targetArray, removals) {
  return targetArray.filter(function (v) {
    return ! removals.includes(v);
  });
}


/**
 * キャラクターID配列をもとに、そこに含まれる/含まれないキャラクターオブジェクト配列を返却する
 * @param {Array} characterObjects キャラクターオブジェクトの配列
 * @param {Array} CharacterIds キャラクターID配列
 * @param {Boolean} [searchFlg=true] 検索値 true（デフォルト）:このキャラクターID配列で取得する false:このキャラクターID配列を含まないよう取得する
 * @return {Array} 検索値に適合したキャラクターオブジェクトの配列
 */
function getCharacterObjectsFromCharacterIds(characterObjects, CharacterIds, searchFlg = true) {
  const resultObjects = [];
  for (let k of Object.keys(characterObjects)) {
    if (CharacterIds.includes(characterObjects[k].characterId) == searchFlg) {
      resultObjects.push(characterObjects[k]);
    }
  }
  return resultObjects;
}


/**
 * オブジェクトを要素に持つ配列に対してキーを指定する。各オブジェクト要素の中のそのキーに対応する値を配列で返却する。
 * @param {Array} objectArray 
 * @param {String} key 
 * @return {Array} 値の配列
 */
function getValuesFromObjectArray(objectArray, key) {
  // console.log(objectArray);
  const resultArray = [];
  for (let i = 0; i < objectArray.length; i++) {
    resultArray.push(objectArray[i][key]);
  }
  return resultArray;
}


/**
 * 昼時間開始時用の初期化を行う
 */
function daytimeInitialize() {
  
  // NPCのCO候補者がいないフラグをfalseにする（昼の最初はいると考えてfalseで初期化。いないときにtrueにする）
  TYRANO.kag.stat.f.notExistCOCandidateNPC = false;

  // 生存しているNPCのcharacterId配列を取得済みかのフラグをfalseにする
  TYRANO.kag.stat.f.gottenSurviveNpcCharacterIds = false;

  // アクション実行オブジェクトを初期化する
  TYRANO.kag.stat.f.pcActionObject = {};
  TYRANO.kag.stat.f.npcActionObject = {};
  TYRANO.kag.stat.f.doActionObject = {};

  // アクション実行回数を初期化する
  TYRANO.kag.stat.f.doActionCount = 0;

  // 再投票カウントを初期化する
  TYRANO.kag.stat.f.revoteCount = 0;

  // ゲーム変数のキャラクターオブジェクトに対する初期化
  for (let cId of Object.keys(TYRANO.kag.stat.f.characterObjects)) {
    // 今日のCO済みフラグをfalseに戻す
    TYRANO.kag.stat.f.characterObjects[cId].isDoneTodaysCO = false;

    // 主張力のcurrentをoriginalと同値に戻す
    TYRANO.kag.stat.f.characterObjects[cId].personality.assertiveness.current = TYRANO.kag.stat.f.characterObjects[cId].personality.assertiveness.original;
  }
}


/**
 * 夜時間開始時用の初期化を行う
 */
function nightInitialize() {
  // 噛み実行済みフラグを最初に初期化しておく。噛んだ後、立てること。人狼が2人以上いたときに、噛み実行済みならスキップするため。
  TYRANO.kag.stat.f.isBiteEnd = false;
}


/**
 * 時間を進めるメソッド
 */
function timePasses() {
  // 昼に呼ばれたら夜に+する
  if (TYRANO.kag.stat.f.isDaytime) {
    TYRANO.kag.stat.f.isDaytime = false;
    nightInitialize(); // 夜時間開始時用の初期化を行う
  } else {
    // 夜に呼ばれたら翌日の昼にする
    TYRANO.kag.stat.f.day++;
    TYRANO.kag.stat.f.isDaytime = true;
    daytimeInitialize(); // 昼時間開始時用の初期化を行う
  }
}


/**
 * role.roleIdやfakeRole.roleIdプロパティをもとに、該当するキャラクターオブジェクトだけを返却する（該当するもの全て返す）
 * @param {Array} characterObjects キャラクターオブジェクトの配列
 * @param {Array} searchRoleIds 検索するroleIdの配列（1件でも配列にすること）
 * @param {Boolean} [searchFlg=true] 検索値 true（デフォルト）:searchRoleIdsに含まれる false:searchRoleIdsに含まれない
 * @param {Boolean} [checkRole=true] 検索値 true（デフォルト）:role.roleIdを確認対象とする false:確認対象としない
 * @param {Boolean} [checkFakeRole=true] 検索値 true:fakeRole.roleIdを確認対象とする false（デフォルト）:確認対象としない
 * @return {Array} 検索値に適合したキャラクターオブジェクトの配列
 */
function getHaveTheRoleObjects(characterObjects, searchRoleIds, searchFlg = true, checkRole = true, checkFakeRole = false) {

  const resultObjects = [];
  for (let k of Object.keys(characterObjects)) {
    if ((checkRole && searchRoleIds.includes(characterObjects[k].role.roleId) == searchFlg) ||
      (checkFakeRole && searchRoleIds.includes(characterObjects[k].fakeRole.roleId) == searchFlg)) {
      resultObjects.push(characterObjects[k]);
    }
  }
  return resultObjects;
}


/**
 * オブジェクト内で、最大である値のキーを取得する
 * @param {Object} object {String:Number, String:Number,...}形式のオブジェクト
 * @returns {Array} Numberが最大だったキーの配列（Numberが同値なら複数）
 */
 function getMaxKeys(object) {
  return Object.keys(object).filter(key => {
    return object[key] == Math.max.apply(null, Object.values(object));
  });
}


/**
 * 渡された変数が配列なら末尾にelementをpushし、そうでなければ配列を作りつつelementを格納する
 * @param {*} array 
 * @param {*} element 
 * @returns 要素を追加した配列
 */
function pushElement(array, element) {
  if (Array.isArray(array)) {
    array.push(element);
  } else {
    array = [element];
  }
  console.log('【pushElement】');
  console.log(array);
  return array;
}


/**
 * オブジェクトをディープコピーするための関数;
 * 第一引数はコピーさせたいオブジェクトを渡す;
 * 第二引数はオブジェクトをどの程度同質にするかをオブジェクトで指定;
 * 例えば{descriptor: false, extensible: false}と指定すると
 * ディスクリプタはコピー元のオブジェクトと同じにならない(全てtrueになる)、
 * そして、オブジェクトの拡張可属性(frozen,sealedなど)は同じにならず、全て拡張可になる;
 * 指定しなければ全てコピー元のオブジェクトと同じになる;
 * 第三引数はコピーさせたくない型(親のprototype)を配列で渡す;
 * 第四引数はコピーさせたくないオブジェクトを配列で渡す;
 * 
 * 使い方;
 * clone(object, homogeneity, excludedPrototypes, excludedObjects);
 * 
 * 引用元：{@link https://webkatu.com/201407132011-clone-function-to-deepcopy-object/}
 * Copyright (c) 2016 shigure
 * Released under the MIT license
 * MITライセンス全文：{@link https://github.com/webkatu/clone.js/blob/master/LICENSE}
 */
var clone = (function() {
  //引数の型を返す関数;
  var typeOf = function(operand) {
    return Object.prototype.toString.call(operand).slice(8, -1);
  };

  //引数がプリミティブかオブジェクトか判定;
  var isPrimitive = function(type) {
    if(type === null) {
      return true;
    }
    if(typeof type === 'object' || typeof type === 'function') {
      return false;
    }
    return true;
  };

  //アクセサプロパティかデータプロパティか判定;
  var isAccessorDescriptor = function(descriptor) {
    return 'get' in descriptor;
  };

  //descriptorを同じにせず、get,set,value以外のdescriptor全てtrueのプロパティを定義;
  var defineProperty = function(cloneObject, propName, descriptor, cloneParams) {
    //cloneの引数が多すぎるのでbindする;
    var boundClone = function(object) {
      return clone(object, cloneParams.homogeneity, cloneParams.excludedPrototypes, cloneParams.excludedObjects, cloneParams.memo);
    };

    if(isAccessorDescriptor(descriptor)) {
      //アクセサプロパティの場合;
      Object.defineProperty(cloneObject, propName, {
        get: boundClone(descriptor.get),
        set: boundClone(descriptor.set),
        enumerable: true,
        configurable: true,
      });
    }else {
      //データプロパティの場合;
      Object.defineProperty(cloneObject, propName, {
        value: boundClone(descriptor.value),
        enumerable: true,
        configurable: true,
        writable: true,
      });
    }
    return cloneObject;
  };

  //descriptorが同じプロパティを定義する;
  var equalizeDescriptor = function(cloneObject, propName, descriptor, cloneParams) {
    //cloneの引数が多すぎるのでbindする;
    var boundClone = function(object) {
      return clone(object, cloneParams.homogeneity, cloneParams.excludedPrototypes, cloneParams.excludedObjects, cloneParams.memo);
    };

    if(isAccessorDescriptor(descriptor)) {
      //アクセサプロパティの場合;
      Object.defineProperty(cloneObject, propName, {
        get: boundClone(descriptor.get),
        set: boundClone(descriptor.set),
        enumerable: descriptor.enumerable,
        configurable: descriptor.configurable,
      });
    }else {
      //データプロパティの場合;
      Object.defineProperty(cloneObject, propName, {
        value: boundClone(descriptor.value),
        enumerable: descriptor.enumerable,
        configurable: descriptor.configurable,
        writable: descriptor.writable,
      });
    }
    return cloneObject;
  };

  //objectの拡張可属性を同じにする;
  var equalizeExtensible = function(object, cloneObject) {
    if(Object.isFrozen(object)) {
      Object.freeze(cloneObject);
      return;
    }
    if(Object.isSealed(object)) {
      Object.seal(cloneObject);
      return;
    }
    if(Object.isExtensible(object) === false) {
      Object.preventExtensions(cloneObject);
      return
    }
  };

  //型を作成するオブジェクト;
  var sameTypeCreater = {
    //引数のobjectの型と同一の型を返すメソッド;
    create: function(object) {
      var type = typeOf(object);
      var method = this[type];
      //console.log('★★type:' + type);

      //ここで列挙されていない型は対応していないので、nullを返す;
      if(method === undefined) {
        return null;
      }
      return this[type](object);
    },
    Object: function(object) {
      //自作クラスはprototype継承される
      return Object.create(Object.getPrototypeOf(object));
    },
    Array: function(object) {
      return new Array();
    },
    Function: function(object) {
      //ネイティブ関数オブジェクトはcloneできないのでnullを返す;
      try {
        var anonymous;
        eval('anonymous = ' + object.toString());
        return anonymous;
      }catch(e) {
        return null;
      }
    },
    Error: function(object) {
      new Object.getPrototypeOf(object).constructor();
    },
    Date: function(object) {
      new Date(object.valueOf());
    },
    RegExp: function(object) {
      new RegExp(object.valueOf());
    },
    Boolean: function(object) {
      new Boolean(object.valueOf());
    },
    String: function(object) {
      new String(object.valueOf());
    },
    Number: function(object) {
      new Number(object.valueOf());
    },
  };

  //memoオブジェクトを作る関数;
  //一度コピーされたオブジェクトはmemoオブジェクトに保存され;
  //二度コピーすることがないようにする(循環参照対策);
  var createMemo = function() {
    var memo = new Object();
    var types = ['Object', 'Array', 'Function', 'Error', 'Date', 'RegExp', 'Boolean', 'String', 'Number'];
    types.forEach(function(type) {
      memo[type] = {
        objects: [],
        cloneObjects: []
      };
    });
    return memo;
  };

  //実際に呼ばれる関数;
  //objectのプロパティを再帰的にコピーし、cloneObjectを返す;
  function clone(object, homogeneity, excludedPrototypes, excludedObjects, memo) {
    //プリミティブ型はそのまま返す;
    if(isPrimitive(object)) {
      return object;
    }
    //cloneしたくない型を持つobjectであれば、参照で返す;
    if(excludedPrototypes.indexOf(Object.getPrototypeOf(object)) !== -1) {
      return object;
    }
    //cloneしたくないobjectであれば、参照で返す;
    if(excludedObjects.indexOf(object) !== -1) {
      return object;
    }

    //objectと同一の型を持つcloneObjectを作成する;
    var cloneObject =  sameTypeCreater.create(object);
    //cloneObjectがnullなら対応していないので参照で返す;
    if(cloneObject === null) {
      return object;
    }

    //循環参照対策 objectが既にmemoに保存されていれば内部参照なので、値渡しではなくcloneObjectに参照先を切り替えたobjectを返す;
    var type = typeOf(object);
    var index = memo[type]['objects'].indexOf(object);
    if(index !== -1) {
      return memo[type]['cloneObjects'][index];
    }

    //循環参照対策 objectはcloneObjectとセットでmemoに追加;
    memo[type]['objects'].push(object);
    memo[type]['cloneObjects'].push(cloneObject);


    var propNames = Object.getOwnPropertyNames(object);
    var cloneParams = {
      homogeneity: homogeneity,
      excludedPrototypes: excludedPrototypes,
      excludedObjects: excludedObjects,
      memo: memo,
    };

    //objectのすべてのプロパティを再帰的にcloneして、cloneObjectのプロパティに加える;
    propNames.forEach(function(propName) {
      var descriptor = Object.getOwnPropertyDescriptor(object, propName);

      if(propName in cloneObject) {
        //オブジェクト生成時に自動的に定義されるネイティブプロパティ(lengthなど)なら
        //ディスクリプタも同一にしてプロパティの内容をクローンする;
        equalizeDescriptor(cloneObject, propName, descriptor, cloneParams);
        return;
      }

      //descriptorを全く同じにするか;
      if(homogeneity.descriptor === false) {
        //同じにしないならプロパティの内容だけクローンする;
        defineProperty(cloneObject, propName, descriptor, cloneParams);
      }else {
        //console.log('ディスクリプタも同一にしてプロパティの内容をクローンする;');
        //ディスクリプタも同一にしてプロパティの内容をクローンする;
        //console.log('start equalizeDescriptor propNames.forEach 3');
        //console.log(cloneObject);
        equalizeDescriptor(cloneObject, propName, descriptor, cloneParams);
        //console.log('end equalizeDescriptor');
        //console.log(cloneObject);
      }
    });

    //objectの拡張可属性(preventExtensible, isSealed, isFrozen)を同一にするか;
    if(homogeneity.extensible !== false) {
      equalizeExtensible(object, cloneObject);
    }
    //クローンしたオブジェクトを返す;
    return cloneObject;
  }

  return function(object, homogeneity, excludedPrototypes, excludedObjects) {
    if(homogeneity === null || typeof homogeneity !== 'object') {
      homogeneity = {};
    }
    if(! Array.isArray(excludedPrototypes)) {
      excludedPrototypes = [];
    }
    if(! Array.isArray(excludedObjects)) {
      excludedObjects = [];
    }
    return clone(object, homogeneity, excludedPrototypes, excludedObjects, createMemo());
  };
})();
