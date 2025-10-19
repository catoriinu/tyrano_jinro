/**
 * Tyranoシナリオにおける横並びキャラクター表示の共通処理ユーティリティ。
 * `*displayCharactersHorizontally` / `*displayCharactersHorizontallyForStatus` から呼び出される。
 */
/* global TYRANO, $, createInfoContainer, isShouldOpenRoleInfo */

/** 画面横幅（px） */
const HORIZONTAL_DISPLAY_CONTAINER_WIDTH = 1280;
/** テキストを描画する際の上下余白（px） */
const DEFAULT_TEXT_MARGIN = 3;
/** キャラクターボックス同士の左右余白（px） */
const DEFAULT_BOX_MARGIN = 3;
/** キャラクター画像用の基準 z-index */
const DEFAULT_IMAGE_Z_INDEX = 1;
/** 縦書き／横書きテキストで使用するフォント */
const DEFAULT_FONT_FAMILY = 'にくまるフォント';
/** テキスト縁取り用のシャドウ設定 */
const HORIZONTAL_TEXT_SHADOW =
  'rgb(255, 255, 255) 2px 0px 0px, rgb(255, 255, 255) 1.76px 0.96px 0px, ' +
  'rgb(255, 255, 255) 1.08px 1.68px 0px, rgb(255, 255, 255) 0.14px 1.99px 0px, ' +
  'rgb(255, 255, 255) -0.83px 1.82px 0px, rgb(255, 255, 255) -1.6px 1.2px 0px, ' +
  'rgb(255, 255, 255) -1.98px 0.28px 0px, rgb(255, 255, 255) -1.87px -0.7px 0px, ' +
  'rgb(255, 255, 255) -1.31px -1.51px 0px, rgb(255, 255, 255) -0.42px -1.96px 0px, ' +
  'rgb(255, 255, 255) 0.57px -1.92px 0px, rgb(255, 255, 255) 1.42px -1.41px 0px, ' +
  'rgb(255, 255, 255) 1.92px -0.56px 0px';

/** 旧マクロが使用していたデフォルトの表示位置調整量（box の右寄せ／上寄せを統一制御する） */
const DEFAULT_CHARACTER_DISPLACEMENT = {
  right: 20,
  top: -100
};

/** 旧 openVote マクロで使用していた表示用文字列群（ログ表示も含めた表記揺れを保持する） */
const OPEN_VOTE_STRINGS = {
  electedMark: '★',
  voteSuffix: '票',
  paddingSpace: '　',
  targetPrefix: '投票→',
  backlogConnector: '→'
};

/** 再投票引き分けを表す定数（環境によっては未定義のため存在チェックする） */
const DRAW_BY_REVOTE_FACTION =
  (typeof FACTION_DRAW_BY_REVOTE !== 'undefined') ? FACTION_DRAW_BY_REVOTE : null;

/**
 * 表示モードごとの描画設定。
 * default: シナリオ画面、status: ステータス画面。
 */
const HORIZONTAL_DISPLAY_CONFIG = {
  default: {
    rootSelector: '.1_fore',
    /** シナリオ画面のレイヤーを初期化 */
    cleanup: function cleanupDefaultRoot($root) {
      $root.find('.dch_container').remove();
      $root.find('.dch_text').remove();
    },
    /** シナリオ画面用のコンテナを生成 */
    getContainer: function createDefaultContainer($root) {
      return $('<div>').addClass('dch_container').appendTo($root);
    },
    /** シナリオ画面での 1 キャラクター分の描画 */
    renderCharacter: function renderDefaultCharacter(options) {
      const {
        $root,
        $container,
        character,
        index,
        boxWidth,
        halfBoxWidth,
        displacedPxToRight,
        displacedPxToTop,
        defaultPos
      } = options;

      const classNum = 'dch_' + index;
      const imageName = 'dch_' + character.characterId + '_' + index;
      const reflectClass = character.reflect ? ' reflect' : '';
      const storagePath = './data/fgimage/chara/' + character.characterId + '/' + character.fileName;
      const boxLeft = (boxWidth * index) + DEFAULT_BOX_MARGIN;
      const widthCenter = Number(defaultPos.widthCenter || 0);
      const imageLeft = (boxWidth * (index + 1)) - halfBoxWidth - widthCenter + displacedPxToRight;
      const imageTop = Number(defaultPos.top || 0) + displacedPxToTop;
      const clipLeft = widthCenter - halfBoxWidth - displacedPxToRight;
      const clipRight = Number(defaultPos.width || 0) - widthCenter - halfBoxWidth + displacedPxToRight;
      const backgroundColor = character.bgColor || 'rgba(0, 0, 0, 1)';

      // キャラクターを収めるボックスを生成
      const $box = $('<div>').addClass('dch_box ' + classNum).css({
        width: boxWidth + 'px',
        'background-image': 'linear-gradient(' + backgroundColor + ' 10%, rgba(0, 0, 0, 1) 150%)'
      });
      $box.appendTo($container);

      // 画像を表示するためのスタイルを算出
      const imageCss = {
        position: 'absolute',
        top: imageTop + 'px',
        left: imageLeft + 'px',
        width: Number(defaultPos.width || 0) + 'px',
        'z-index': DEFAULT_IMAGE_Z_INDEX,
        'clip-path': buildClipPath(clipLeft, clipRight)
      };

      const imageHeight = getCharacterHeight(defaultPos);
      if (imageHeight) {
        imageCss.height = imageHeight + 'px';
      }

      $('<img>').attr({
        src: storagePath,
        'class': imageName + reflectClass
      }).css(imageCss).appendTo($box);

      appendVerticalText($root, character.leftText, boxLeft);
      appendTopText($root, character.topText, boxLeft, boxWidth);
    }
  },
  status: {
    rootSelector: '.dchStatusContainer',
    /** ステータス画面のレイヤーを初期化 */
    cleanup: function cleanupStatusRoot($root) {
      $root.find('.statusBox').remove();
    },
    /** ステータス画面は既存のコンテナに直接追加する */
    getContainer: function getStatusContainer($root) {
      return $root;
    },
    /** ステータス画面での 1 キャラクター分の描画 */
    renderCharacter: function renderStatusCharacter(options) {
      const {
        $container,
        character,
        index,
        boxWidth,
        halfBoxWidth,
        displacedPxToRight,
        displacedPxToTop,
        defaultPos,
        f
      } = options;

      const classNum = 'dch_' + index;
      const imageName = 'dch_' + character.characterId + '_' + index;
      const reflectClass = character.reflect ? ' reflect' : '';
      const storagePath = './data/fgimage/chara/' + character.characterId + '/' + character.fileName;
      const widthCenter = Number(defaultPos.widthCenter || 0);
      const imageLeft = boxWidth - halfBoxWidth - widthCenter + displacedPxToRight;
      const imageTop = Number(defaultPos.top || 0) + displacedPxToTop;
      const clipLeft = widthCenter - halfBoxWidth - displacedPxToRight;
      const clipRight = Number(defaultPos.width || 0) - widthCenter - halfBoxWidth + displacedPxToRight;
      const backgroundColor = character.bgColor || 'rgba(0, 0, 0, 1)';

      // ステータス用ボックスを構築
      const $statusBox = $('<div>').attr({
        'class': 'statusBox ' + classNum
      }).css({
        width: boxWidth + 'px',
        'background-image': 'linear-gradient(to bottom, ' + backgroundColor + ' 5%, rgba(0, 0, 0, 1) 130%)'
      });

      $('<p>').attr({
        'class': 'statusBoxVerticalText ' + classNum + 'VerticalText'
      }).css({
        'text-shadow': $.generateTextShadowStrokeCSS('2px #FFFFFF')
      }).text(character.leftText || '').appendTo($statusBox);

      const statusImageCss = {
        top: imageTop + 'px',
        left: imageLeft + 'px',
        width: Number(defaultPos.width || 0) + 'px',
        'clip-path': buildClipPath(clipLeft, clipRight)
      };

      const statusImageHeight = getCharacterHeight(defaultPos);
      if (statusImageHeight) {
        statusImageCss.height = statusImageHeight + 'px';
      }

      $('<img>').attr({
        src: storagePath,
        'class': 'statusBoxCharaImg ' + imageName + reflectClass
      }).css(statusImageCss).appendTo($statusBox);

      if (typeof isShouldOpenRoleInfo === 'function' && typeof createInfoContainer === 'function') {
        const shouldOpenRoleInfo = isShouldOpenRoleInfo(
          f.characterObjects,
          character.characterId,
          f.winnerFaction,
          f.commonPerspective
        );
        const $infoContainer = createInfoContainer(
          f.characterObjects,
          character.characterId,
          boxWidth,
          shouldOpenRoleInfo
        );
        if ($infoContainer && $infoContainer.appendTo) {
          $infoContainer.appendTo($statusBox);
        }
      }

      $statusBox.appendTo($container);
    }
  }
};

/**
 * 横並び表示を実行する。
 * @param {'default' | 'status'} mode 表示モード
 */
function renderHorizontalCharacters(mode) {
  const config = HORIZONTAL_DISPLAY_CONFIG[mode];
  // 想定外のモードが来た場合は開発者向けに例外を投げて早期に気付けるようにする
  if (!config) {
    throw new Error('[renderHorizontalCharacters] 未対応のモードです: ' + mode);
  }

  // Tyrano本体が初期化されていない場合は描画処理を行わない
  const kag = (typeof TYRANO !== 'undefined' && TYRANO && TYRANO.kag) ? TYRANO.kag : null;
  if (!kag || !kag.stat) {
    return;
  }

  const f = kag.stat.f || {};
  const dch = f.dch || {};
  const characterList = Array.isArray(dch.characterList) ? dch.characterList : [];
  const defaultPosition = f.defaultPosition || {};
  const displacedPxToRight = Number(dch.displacedPxToRight || 0);
  const displacedPxToTop = Number(dch.displacedPxToTop || 0);

  const $root = $(config.rootSelector);
  if ($root.length === 0) {
    return;
  }

  // 描画前に対象レイヤーを一度クリーンナップする
  if (typeof config.cleanup === 'function') {
    config.cleanup($root);
  }

  if (!characterList.length) {
    return;
  }

  const containerWidth = HORIZONTAL_DISPLAY_CONTAINER_WIDTH;
  const boxWidth = containerWidth / characterList.length;
  const halfBoxWidth = boxWidth / 2;
  const $container = config.getContainer($root);

  // モードごとの描画ロジックに委譲して各キャラクターを配置する
  for (let idx = 0; idx < characterList.length; idx += 1) {
    const character = characterList[idx];
    if (!character || !character.characterId) {
      continue;
    }

    const defaultPos = defaultPosition[character.characterId];
    if (!defaultPos) {
      continue;
    }

    config.renderCharacter({
      $root: $root,
      $container: $container,
      character: character,
      index: idx,
      boxWidth: boxWidth,
      halfBoxWidth: halfBoxWidth,
      displacedPxToRight: displacedPxToRight,
      displacedPxToTop: displacedPxToTop,
      defaultPos: defaultPos,
      f: f
    });
  }
}

/**
 * クリップ用の CSS 文字列を生成する。
 * @param {number} clipLeft 左側からどれだけ切り取るか（px）
 * @param {number} clipRight 右側からどれだけ切り取るか（px）
 * @returns {string} clip-path の値
 */
function buildClipPath(clipLeft, clipRight) {
  const left = sanitizeClipValue(clipLeft);
  const right = sanitizeClipValue(clipRight);
  return 'inset(0px ' + right + 'px 0px ' + left + 'px)';
}

/**
 * クリップ量を正規化する。
 * @param {number} value 入力値
 * @returns {number} 0 以上の整数値
 */
function sanitizeClipValue(value) {
  if (Number.isFinite(value)) {
    return Math.max(0, Math.round(value));
  }
  return 0;
}

/**
 * キャラクター画像の高さを取得する。
 * @param {Object} defaultPos デフォルト位置情報
 * @returns {number|undefined} 高さ（px）
 */
function getCharacterHeight(defaultPos) {
  if (defaultPos && Number.isFinite(Number(defaultPos.haight))) {
    return Number(defaultPos.haight);
  }
  if (defaultPos && Number.isFinite(Number(defaultPos.height))) {
    return Number(defaultPos.height);
  }
  return undefined;
}

/**
 * 縦書きテキストをレイヤーに追加する。
 * @param {JQuery} $root レイヤー要素
 * @param {string} text 表示する文字列
 * @param {number} boxLeft 左端の位置（px）
 */
function appendVerticalText($root, text, boxLeft) {
  if (!text) {
    return;
  }
  $('<p>').addClass('vertical_text dch_text').css({
    position: 'absolute',
    top: DEFAULT_TEXT_MARGIN + 'px',
    left: boxLeft + 'px',
    'text-align': 'left',
    color: '#28332a',
    'font-size': '38px',
    'font-family': DEFAULT_FONT_FAMILY,
    'z-index': 999,
    'text-shadow': HORIZONTAL_TEXT_SHADOW,
    'writing-mode': 'vertical-rl',
    'text-orientation': 'upright'
  }).text(text).appendTo($root);
}

/**
 * 横書きテキストをレイヤーに追加する。
 * @param {JQuery} $root レイヤー要素
 * @param {string} text 表示する文字列
 * @param {number} boxLeft 左端の位置（px）
 * @param {number} boxWidth ボックス幅（px）
 */
function appendTopText($root, text, boxLeft, boxWidth) {
  if (!text) {
    return;
  }
  $('<p>').addClass('dch_text dch_top_text').css({
    position: 'absolute',
    top: DEFAULT_TEXT_MARGIN + 'px',
    left: boxLeft + 'px',
    width: boxWidth + 'px',
    'text-align': 'center',
    color: '#28332a',
    'font-size': '38px',
    'font-family': DEFAULT_FONT_FAMILY,
    'z-index': 999,
    'text-shadow': HORIZONTAL_TEXT_SHADOW
  }).text(text).appendTo($root);
}

window.renderHorizontalCharacters = renderHorizontalCharacters;

/**
 * `f.dch` に横並び表示用データを組み立てる。
 * @param {'introduction'|'status'|'winnerFaction'|'openVote'} mode 表示準備モード
 * @param {Object} [options] 将来的な拡張用オプション
 * @returns {{dch: DisplayCharactersHorizontally, extras?: Object}|null} 設定したオブジェクトと付随情報
 */
function prepareHorizontalCharacters(mode, options) {
  const context = createHorizontalDisplayContext(options);
  if (!context) {
    return null;
  }

  const preparer = HORIZONTAL_DISPLAY_PREPARERS[mode];
  if (!preparer) {
    throw new Error('[prepareHorizontalCharacters] 未対応のモードです: ' + mode);
  }

  const dch = preparer(context);
  if (!dch) {
    return null;
  }

  context.f.dch = dch;
  const result = {
    dch: dch
  };
  if (context.extras && Object.keys(context.extras).length > 0) {
    result.extras = context.extras;
  }
  return result;
}

/**
 * 横並び表示用のコンテキストを生成する。
 * @param {Object} [options] 呼び出し側から渡される追加オプション
 * @returns {{kag: *, f: *, mp: *, tf: *, options: Object, extras: Object}|null}
 */
function createHorizontalDisplayContext(options) {
  const kag = (typeof TYRANO !== 'undefined' && TYRANO && TYRANO.kag) ? TYRANO.kag : null;
  if (!kag || !kag.stat) {
    return null;
  }
  if (!kag.stat.tf) {
    kag.stat.tf = {};
  }
  return {
    kag: kag,
    f: kag.stat.f || {},
    mp: kag.stat.mp || {},
    tf: kag.stat.tf,
    options: options || {},
    extras: {}
  };
}

/**
 * `DisplayCharactersHorizontallySingle` を生成するヘルパー。
 * 必須プロパティ以外は既存マクロのデフォルト値（通常立ち絵など）に合わせる。
 * @param {Object} params パラメータ
 * @returns {DisplayCharactersHorizontallySingle}
 */
function createHorizontalCharacter(params) {
  const fileName = (typeof params.fileName === 'undefined') ? 'normal.png' : params.fileName;
  return new DisplayCharactersHorizontallySingle(
    params.characterId,
    fileName,
    typeof params.bgColor === 'undefined' ? '' : params.bgColor,
    typeof params.topText === 'undefined' ? '' : params.topText,
    typeof params.leftText === 'undefined' ? '' : params.leftText,
    typeof params.reflect === 'undefined' ? false : params.reflect
  );
}

/**
 * `DisplayCharactersHorizontally` を生成するヘルパー。
 * @param {Array<DisplayCharactersHorizontallySingle>} characterList キャラクターリスト
 * @param {{right: number, top: number}} displacement 表示位置調整量
 * @returns {DisplayCharactersHorizontally}
 */
function createHorizontalDisplay(characterList, displacement) {
  return new DisplayCharactersHorizontally(
    characterList,
    displacement.right,
    displacement.top
  );
}

/**
 * 表示モード別の `f.dch` 組み立てロジック。
 */
const HORIZONTAL_DISPLAY_PREPARERS = {
  introduction: function prepareIntroductionCharacters(context) {
    const f = context.f || {};
    const characterObjects = f.characterObjects || {};
    const participantsIdList = Array.isArray(f.participantsIdList) ? f.participantsIdList : [];
    const characterList = [];

    for (let idx = 0; idx < participantsIdList.length; idx += 1) {
      const characterId = participantsIdList[idx];
      if (!characterId) {
        continue;
      }
      const characterObject = characterObjects[characterId] || {};
      const bgColor = (typeof getBgColorFromCharacterId === 'function')
        ? getBgColorFromCharacterId(characterId)
        : '';
      const reflect = (typeof getReflectFromCharacterId === 'function')
        ? getReflectFromCharacterId(characterId)
        : false;

      characterList.push(createHorizontalCharacter({
        characterId: characterId,
        fileName: 'normal.png',
        bgColor: bgColor,
        leftText: characterObject.name || '',
        reflect: reflect
      }));
    }

    return createHorizontalDisplay(characterList, DEFAULT_CHARACTER_DISPLACEMENT);
  },
  status: function prepareStatusCharacters(context) {
    const f = context.f || {};
    const mp = context.mp || {};
    const characterObjects = f.characterObjects || {};
    const statusFace = f.statusFace || {};
    const participantsIdList = Array.isArray(f.participantsIdList) ? f.participantsIdList : [];
    const characterList = [];
    const winnerFaction = mp.winnerFaction;

    for (let idx = 0; idx < participantsIdList.length; idx += 1) {
      const characterId = participantsIdList[idx];
      if (!characterId) {
        continue;
      }
      const characterObject = characterObjects[characterId] || {};
      const statusFaceEntry = statusFace[characterId] || {};
      const isAlive = Boolean(characterObject.isAlive);
      const bgColor = (typeof getBgColorFromCharacterId === 'function')
        ? getBgColorFromCharacterId(characterId, isAlive)
        : '';
      let fileName = statusFaceEntry.alive || '';

      if (winnerFaction == null) {
        fileName = isAlive ? (statusFaceEntry.alive || '') : (statusFaceEntry.lose || '');
      } else if (
        (DRAW_BY_REVOTE_FACTION !== null && winnerFaction === DRAW_BY_REVOTE_FACTION) ||
        winnerFaction === 'DRAW_BY_REVOTE'
      ) {
        fileName = statusFaceEntry.draw || fileName;
      } else if (characterObject.role && characterObject.role.faction === winnerFaction) {
        fileName = (statusFaceEntry.win && statusFaceEntry.win[winnerFaction]) || fileName;
      } else {
        fileName = statusFaceEntry.lose || fileName;
      }

      characterList.push(createHorizontalCharacter({
        characterId: characterId,
        fileName: fileName,
        bgColor: bgColor,
        leftText: characterObject.name || '',
        reflect: (typeof getReflectFromCharacterId === 'function')
          ? getReflectFromCharacterId(characterId)
          : false
      }));
    }

    return createHorizontalDisplay(characterList, DEFAULT_CHARACTER_DISPLACEMENT);
  },
  winnerFaction: function prepareWinnerFactionCharacters(context) {
    const f = context.f || {};
    const mp = context.mp || {};
    const characterObjects = f.characterObjects || {};
    const statusFace = f.statusFace || {};
    const participantsIdList = Array.isArray(f.participantsIdList) ? f.participantsIdList : [];
    const characterList = [];
    const winnerFaction = mp.winnerFaction;

    for (let idx = 0; idx < participantsIdList.length; idx += 1) {
      const characterId = participantsIdList[idx];
      if (!characterId) {
        continue;
      }
      const characterObject = characterObjects[characterId] || {};
      const statusFaceEntry = statusFace[characterId] || {};

      let fileName = '';
      if (
        (DRAW_BY_REVOTE_FACTION !== null && winnerFaction === DRAW_BY_REVOTE_FACTION) ||
        winnerFaction === 'DRAW_BY_REVOTE'
      ) {
        fileName = statusFaceEntry.draw || '';
      } else if (characterObject.role && characterObject.role.faction === winnerFaction) {
        fileName = (statusFaceEntry.win && statusFaceEntry.win[winnerFaction]) || '';
      } else {
        continue;
      }

      characterList.push(createHorizontalCharacter({
        characterId: characterId,
        fileName: fileName,
        bgColor: (typeof getBgColorFromCharacterId === 'function')
          ? getBgColorFromCharacterId(characterId)
          : '',
        leftText: characterObject.name || '',
        reflect: (typeof getReflectFromCharacterId === 'function')
          ? getReflectFromCharacterId(characterId)
          : false
      }));
    }

    return createHorizontalDisplay(characterList, DEFAULT_CHARACTER_DISPLACEMENT);
  },
  openVote: function prepareOpenVoteCharacters(context) {
    const f = context.f || {};
    const tf = context.tf || {};
    const characterObjects = f.characterObjects || {};
    const voteResultObjects = Array.isArray(f.voteResultObjects) ? f.voteResultObjects : [];
    const votedCountObject = f.votedCountObject || {};
    const electedIdList = Array.isArray(f.electedIdList) ? f.electedIdList : [];
    const characterList = [];
    const backlogParts = [];

    for (let idx = 0; idx < voteResultObjects.length; idx += 1) {
      const voteResult = voteResultObjects[idx] || {};
      const characterId = voteResult.characterId;
      if (!characterId) {
        continue;
      }
      const targetId = voteResult.targetId;
      const actorObject = characterObjects[characterId] || {};
      const targetObject = characterObjects[targetId] || {};

      const electedMark = electedIdList.includes(characterId) ? OPEN_VOTE_STRINGS.electedMark : '';
      const voteCount = (characterId in votedCountObject) ? votedCountObject[characterId] : 0;
      const voteCountText = electedMark + voteCount + OPEN_VOTE_STRINGS.voteSuffix;

      characterList.push(createHorizontalCharacter({
        characterId: characterId,
        fileName: 'normal.png',
        bgColor: (typeof getBgColorFromCharacterId === 'function')
          ? getBgColorFromCharacterId(targetId)
          : '',
        topText: voteCountText,
        leftText: OPEN_VOTE_STRINGS.targetPrefix + (targetObject.name || ''),
        reflect: (typeof getReflectFromCharacterId === 'function')
          ? getReflectFromCharacterId(characterId)
          : false
      }));

      let backlogCountText = voteCountText;
      if (!backlogCountText.startsWith(OPEN_VOTE_STRINGS.electedMark)) {
        backlogCountText = OPEN_VOTE_STRINGS.paddingSpace + backlogCountText;
      }
      const backlogLine = backlogCountText + ' ' + (actorObject.name || '') + OPEN_VOTE_STRINGS.backlogConnector + (targetObject.name || '');
      backlogParts.push(backlogLine);
    }

    // 既存マクロが参照する `tf.voteBacklog` と戻り値の両方に同じ文字列を格納する
    const backlogText = backlogParts.join('<br>');
    tf.voteBacklog = backlogText;
    context.extras.backlogText = backlogText;

    return createHorizontalDisplay(characterList, DEFAULT_CHARACTER_DISPLACEMENT);
  }
};

window.prepareHorizontalCharacters = prepareHorizontalCharacters;
