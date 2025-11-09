/**
 * Tyranoシナリオにおけるキャラクターボード表示の共通処理ユーティリティ。
 * `*renderCharacterBoard` / `*renderCharacterBoardForStatus` から呼び出される。
 */
/* global TYRANO, $, createInfoContainer, isShouldOpenRoleInfo */

/** 画面横幅（px） */
const CHARACTER_BOARD_CONTAINER_WIDTH = 1280;
/* キャラクターボードのサイズクラス接頭語 */
const CHARACTER_BOARD_SIZE_CLASS_PREFIX = 'cb_size_';

/** 旧マクロが使用していたデフォルトの表示位置調整量（box の右寄せ／上寄せを統一制御する） */
const DEFAULT_BOARD_OFFSET = {
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

/** キャラクターボードを1段で表示する人数上限のデフォルト */
const DEFAULT_MAX_SINGLE_ROW_COUNT = 10;
/** キャラクターボード多段表示の組み合わせプリセット */
const DEFAULT_MULTI_ROW_OVERRIDES = Object.freeze({
  11: [5, 6],
  12: [6, 6],
  21: [7, 7, 7],
  22: [7, 7, 8]
});
/** 多段表示のデフォルト設定 */
const DEFAULT_MULTI_ROW_CONFIG = Object.freeze({
  maxSingleRowCount: DEFAULT_MAX_SINGLE_ROW_COUNT,
  rowOverrides: DEFAULT_MULTI_ROW_OVERRIDES
});

/** キャラクターボックスの標準高さ(px) */
/** キャラクターボードの表示領域上限(px) */
const DEFAULT_CHARACTER_BOARD_AREA_HEIGHT = 720;
/** キャラクター描画の基準高さ(px) */
const DEFAULT_CHARACTER_BOX_HEIGHT = 720;
/** ステータス画面のキャラクターボックス高さ(px) */
/** ステータス表示のボード領域上限(px) */
const STATUS_CHARACTER_BOARD_AREA_HEIGHT = 584;
/** ステータス時の描画基準高さ(px) */
const STATUS_CHARACTER_BOX_HEIGHT = 584;
const DEFAULT_ROW_SCALE_BY_ROW_COUNT = Object.freeze({
  1: 1,
  2: 0.75,
  3: 0.5
});

/**
 * 表示モードごとの描画設定。
 * default: シナリオ画面、status: ステータス画面。
 */
const CHARACTER_BOARD_CONFIG = {
  default: {
    rootSelector: '.1_fore',
    boxBaseHeight: DEFAULT_CHARACTER_BOX_HEIGHT,
    boxAreaHeight: DEFAULT_CHARACTER_BOARD_AREA_HEIGHT,
    multiRow: DEFAULT_MULTI_ROW_CONFIG,
    rowScaleOverrides: DEFAULT_ROW_SCALE_BY_ROW_COUNT,
    /** シナリオ画面のレイヤーを初期化 */
    cleanup: function cleanupDefaultRoot($root) {
      $root.find('.cb_container').remove();
      $root.find('.cb_text').remove();
    },
    /** シナリオ画面用のコンテナを生成 */
    getContainer: function createDefaultContainer($root) {
      return $('<div>').addClass('cb_container').appendTo($root);
    },
    /** シナリオ画面での 1 キャラクター分の描画 */
    renderCharacter: function renderDefaultCharacter(options) {
      const {
        $container,
        character,
        index,
        boxWidth,
        halfBoxWidth,
        boxHeight,
        displacedPxToRight,
        displacedPxToTop,
        defaultPos,
        rowScale,
        layout
      } = options;

      const resolvedRowScale = resolveRowScaleValue(rowScale);
      const classNum = 'cb_' + index;
      const imageName = 'cb_' + character.characterId + '_' + index;
      const storagePath = './data/fgimage/chara/' + character.characterId + '/' + character.fileName;
      const defaultWidthCenterValue = Number(defaultPos.widthCenter);
      const rawWidthCenter = Number.isFinite(defaultWidthCenterValue) ? defaultWidthCenterValue : 0;
      const widthCenter = rawWidthCenter * resolvedRowScale;
      const boxCenter = halfBoxWidth;
      const imageLeftBase = boxCenter - widthCenter;
      const rowTopOffset = Number.isFinite(options.rowTopOffset) ? Number(options.rowTopOffset) : 0;
      const defaultTopValue = Number(defaultPos.top);
      const totalRows = Number.isInteger(options.rows) ? options.rows : null;
      const baseImageTop = resolveCharacterTop(defaultPos, totalRows);
      const defaultWidthValue = Number(defaultPos.width);
      const rawImageWidth = Number.isFinite(defaultWidthValue) ? defaultWidthValue : 0;
      const imageWidth = rawImageWidth * resolvedRowScale;
      const clipLeft = widthCenter - halfBoxWidth - displacedPxToRight;
      const clipRight = imageWidth - widthCenter - halfBoxWidth + displacedPxToRight;
      const resolvedBoxHeight = Number.isFinite(boxHeight) ? boxHeight : DEFAULT_CHARACTER_BOX_HEIGHT;
      const backgroundColor = character.bgColor || 'rgba(0, 0, 0, 1)';
      const rowIndex = Number.isInteger(options.rowIndex) ? options.rowIndex : null;
      const columnIndex = Number.isInteger(options.columnIndex) ? options.columnIndex : null;

      // キャラクターを収めるボックスを生成
      const boxCss = {
        width: boxWidth + 'px',
        height: resolvedBoxHeight + 'px',
        '--cb-background-color': backgroundColor,
        '--cb-board-offset-x': displacedPxToRight + 'px',
        '--cb-board-offset-y': displacedPxToTop + 'px',
        '--cb-row-offset': rowTopOffset + 'px',
        '--cb-box-height': resolvedBoxHeight + 'px',
        '--cb-box-scale': resolvedRowScale
      };
      const $box = $('<div>').addClass('cb_box ' + classNum).css(boxCss);

      if (rowIndex !== null) {
        $box.addClass('cb_row_index_' + rowIndex);
        $box.attr('data-cb-row-index', rowIndex);
      }
      if (columnIndex !== null) {
        $box.attr('data-cb-column-index', columnIndex);
      }

      $box.appendTo($container);

      // 画像を表示するためのスタイルを算出
      const imageCss = {
        top: 'calc(' + baseImageTop + 'px + var(--cb-board-offset-y, 0px) + var(--cb-row-offset, 0px))',
        left: 'calc(' + imageLeftBase + 'px + var(--cb-board-offset-x, 0px))',
        width: imageWidth + 'px',
        'clip-path': buildClipPath(clipLeft, clipRight)
      };

      const imageHeight = getCharacterHeight(defaultPos);
      if (imageHeight) {
        imageCss.height = (imageHeight * resolvedRowScale) + 'px';
      }

      const imageClassNames = ['cb_character_image', imageName];
      if (character.reflect) {
        imageClassNames.push('reflect');
      }

      $('<img>').attr({
        src: storagePath,
        'class': imageClassNames.join(' ')
      }).css(imageCss).appendTo($box);

      appendVerticalText($box, character.leftText);
      appendTopText($box, character.topText);
    }
  },
  status: {
    rootSelector: '.cbStatusContainer',
    boxBaseHeight: STATUS_CHARACTER_BOX_HEIGHT,
    boxAreaHeight: STATUS_CHARACTER_BOARD_AREA_HEIGHT,
    multiRow: DEFAULT_MULTI_ROW_CONFIG,
    rowScaleOverrides: DEFAULT_ROW_SCALE_BY_ROW_COUNT,
    /** ステータス画面のレイヤーを初期化 */
    cleanup: function cleanupStatusRoot($root) {
      $root.find('.statusBox').remove();
      $root.find('.cb_row').remove();
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
        boxHeight,
        displacedPxToRight,
        displacedPxToTop,
        defaultPos,
        rowTopOffset,
        f,
        rowScale,
        layout,
        rows
      } = options;

      const resolvedRowScale = resolveRowScaleValue(rowScale);
      const classNum = 'cb_' + index;
      const imageName = 'cb_' + character.characterId + '_' + index;
      const storagePath = './data/fgimage/chara/' + character.characterId + '/' + character.fileName;
      const widthCenterRaw = Number(defaultPos.widthCenter || 0);
      const widthCenter = widthCenterRaw * resolvedRowScale;
      const imageLeft = boxWidth - halfBoxWidth - widthCenter + displacedPxToRight;
      const additionalRowOffset = Number.isFinite(rowTopOffset) ? rowTopOffset : 0;
      const totalRows = Number.isInteger(rows) ? rows : null;
      const baseImageTop = resolveCharacterTop(defaultPos, totalRows);
      const imageTop = baseImageTop + displacedPxToTop + additionalRowOffset;
      const widthRaw = Number(defaultPos.width || 0);
      const imageWidth = widthRaw * resolvedRowScale;
      const clipLeft = widthCenter - halfBoxWidth - displacedPxToRight;
      const clipRight = imageWidth - widthCenter - halfBoxWidth + displacedPxToRight;
      const backgroundColor = character.bgColor || 'rgba(0, 0, 0, 1)';

      // ステータス用ボックスを構築
      const resolvedBoxHeight = Number.isFinite(boxHeight) ? boxHeight : STATUS_CHARACTER_BOX_HEIGHT;
      const $statusBox = $('<div>').attr({
        'class': 'statusBox ' + classNum
      }).css({
        width: boxWidth + 'px',
        height: resolvedBoxHeight + 'px',
        '--status-box-height': resolvedBoxHeight + 'px',
        '--cb-box-scale': resolvedRowScale
      });
      $statusBox.css('--status-background-color', backgroundColor);

      const $verticalText = $('<p>').attr({
        'class': 'statusBoxVerticalText ' + classNum + 'VerticalText'
      }).text(character.leftText || '').appendTo($statusBox);
      if (typeof $ !== 'undefined' && $ && typeof $.generateTextShadowStrokeCSS === 'function') {
        const strokeCss = $.generateTextShadowStrokeCSS('2px #FFFFFF');
        if (strokeCss) {
          $verticalText.css('--status-vertical-text-shadow', strokeCss);
        }
      }

      const statusImageCss = {
        top: imageTop + 'px',
        left: imageLeft + 'px',
        width: imageWidth + 'px',
        'clip-path': buildClipPath(clipLeft, clipRight)
      };

      const statusImageHeight = getCharacterHeight(defaultPos);
      if (statusImageHeight) {
        statusImageCss.height = (statusImageHeight * resolvedRowScale) + 'px';
      }

      const statusImageClassNames = ['statusBoxCharaImg', imageName];
      if (character.reflect) {
        statusImageClassNames.push('reflect');
      }

      $('<img>').attr({
        src: storagePath,
        'class': statusImageClassNames.join(' ')
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
function renderCharacterBoard(mode) {
  const config = CHARACTER_BOARD_CONFIG[mode];
  // 想定外のモードが来た場合は開発者向けに例外を投げて早期に気付けるようにする
  if (!config) {
    throw new Error('[renderCharacterBoard] 未対応のモードです: ' + mode);
  }

  // Tyrano本体が初期化されていない場合は描画処理を行わない
  const kag = (typeof TYRANO !== 'undefined' && TYRANO && TYRANO.kag) ? TYRANO.kag : null;
  if (!kag || !kag.stat) {
    return;
  }

  const f = kag.stat.f || {};
  const board = f.characterBoard || {};
  const characterList = Array.isArray(board.characterList) ? board.characterList : [];
  const defaultPosition = f.defaultPosition || {};
  const displacedPxToRight = Number(board.displacedPxToRight || 0);
  const displacedPxToTop = Number(board.displacedPxToTop || 0);
  const sizePreset = (typeof board.sizePreset === 'string' && board.sizePreset.length > 0)
    ? board.sizePreset
    : null;
  const layoutOptions = (board.layout && typeof board.layout === 'object') ? board.layout : null;

  const $root = $(config.rootSelector);
  if ($root.length === 0) {
    return;
  }
  stripCharacterBoardSizeClasses($root);

  // 描画前に対象レイヤーを一度クリーンナップする
  if (typeof config.cleanup === 'function') {
    config.cleanup($root);
  }

  if (!characterList.length) {
    return;
  }

  const containerWidth = CHARACTER_BOARD_CONTAINER_WIDTH;
  const columnsPerRow = Array.isArray(board.columnsPerRow) ? board.columnsPerRow : null;
  const baseBoxHeight = Number.isFinite(config.boxBaseHeight) ? config.boxBaseHeight : DEFAULT_CHARACTER_BOX_HEIGHT;
  const rowScaleOverrides = config.rowScaleOverrides || DEFAULT_ROW_SCALE_BY_ROW_COUNT;
  const layoutInfo = createCharacterBoardLayoutInfo(
    characterList.length,
    containerWidth,
    layoutOptions,
    columnsPerRow,
    baseBoxHeight,
    rowScaleOverrides,
    config.boxAreaHeight
  );
  const $container = config.getContainer($root);
  applyCharacterBoardSizeClass($root, $container, sizePreset);
  if (typeof console !== 'undefined' && console && typeof console.debug === 'function') {
    console.debug('[renderCharacterBoard] mode=%s characters=%d columns=%d rows=%d columnsPerRow=%o boxHeight=%f layout=%o',
      mode,
      characterList.length,
      layoutInfo.maxColumns || layoutInfo.columns,
      layoutInfo.rows,
      layoutInfo.columnsPerRow || null,
      layoutInfo.boxHeight || baseBoxHeight,
      board.layout || null
    );
  }

  // モードごとの描画ロジックに委譲して各キャラクターを配置する
  if ($container && typeof $container.css === 'function') {
    $container.css('--cb-column-gap', layoutInfo.columnGap + 'px');
    $container.css('--cb-row-gap', layoutInfo.rowGap + 'px');
  }
  const shouldUseSpacer = mode === 'default';
  const rowContainers = [];
  const pendingRightSpacers = [];
  const resolvedColumnsPerRow = Array.isArray(layoutInfo.columnsPerRow) ? layoutInfo.columnsPerRow : [];
  if (resolvedColumnsPerRow.length > 0) {
    for (let rowIdx = 0; rowIdx < resolvedColumnsPerRow.length; rowIdx += 1) {
      const $row = $('<div>').addClass('cb_row').attr('data-cb-row-index', rowIdx);
      const rowHeight = (Array.isArray(layoutInfo.boxHeightByRow) && layoutInfo.boxHeightByRow[rowIdx]) ?
        layoutInfo.boxHeightByRow[rowIdx]
        : layoutInfo.boxHeight;
      if (typeof $row.css === 'function') {
        $row.css('--cb-column-gap', layoutInfo.columnGap + 'px');
        $row.css('min-height', rowHeight + 'px');
      }
      $row.appendTo($container);
      rowContainers[rowIdx] = $row;
      const actualColumns = resolvedColumnsPerRow[rowIdx] || 0;
      if (shouldUseSpacer && layoutInfo.maxColumns > actualColumns) {
        const spacerWidth = layoutInfo.boxWidth / 2;
        const $leftSpacer = createCharacterBoardSpacer(spacerWidth, rowHeight);
        $leftSpacer.attr('data-cb-row-index', rowIdx);
        $row.append($leftSpacer);
        const $rightSpacer = createCharacterBoardSpacer(spacerWidth, rowHeight);
        $rightSpacer.attr('data-cb-row-index', rowIdx);
        pendingRightSpacers.push({
          $row: $row,
          $spacer: $rightSpacer
        });
      }
    }
  } else {
    rowContainers[0] = $container;
  }

  for (let idx = 0; idx < characterList.length; idx += 1) {
    const character = characterList[idx];
    if (!character || !character.characterId) {
      continue;
    }

    const defaultPos = defaultPosition[character.characterId];
    if (!defaultPos) {
      if (typeof console !== 'undefined' && console && typeof console.warn === 'function') {
        console.warn('[renderCharacterBoard] defaultPos not found mode=%s characterId=%s index=%d', mode, character.characterId, idx);
      }
      continue;
    }

    const itemLayout = getCharacterBoardItemLayout(layoutInfo, idx);
    const rowHeight = (Array.isArray(layoutInfo.boxHeightByRow) && layoutInfo.boxHeightByRow[itemLayout.rowIndex])
      ? layoutInfo.boxHeightByRow[itemLayout.rowIndex]
      : layoutInfo.boxHeight;
    const rowScale = getRowScaleForRow(layoutInfo, itemLayout.rowIndex);

    let $targetContainer = $container;
    if (Array.isArray(rowContainers) && rowContainers.length > 0) {
      const candidateRow = rowContainers[itemLayout.rowIndex];
      if (candidateRow && candidateRow.length) {
        $targetContainer = candidateRow;
      } else {
        const fallbackRow = rowContainers[rowContainers.length - 1];
        if (fallbackRow && fallbackRow.length) {
          $targetContainer = fallbackRow;
        }
      }
    }

    config.renderCharacter({
      $root: $root,
      $container: $targetContainer,
      character: character,
      index: idx,
      boxWidth: layoutInfo.boxWidth,
      halfBoxWidth: layoutInfo.halfBoxWidth,
      boxHeight: rowHeight,
      boxLeft: itemLayout.boxLeft,
      columnIndex: itemLayout.columnIndex,
      rowIndex: itemLayout.rowIndex,
      rowTopOffset: itemLayout.rowTopOffset,
      rowScale: rowScale,
      layout: layoutInfo,
      rows: layoutInfo.rows,
      displacedPxToRight: displacedPxToRight,
      displacedPxToTop: displacedPxToTop,
      defaultPos: defaultPos,
      f: f
    });
  }

  if (shouldUseSpacer) {
    for (let spacerIdx = 0; spacerIdx < pendingRightSpacers.length; spacerIdx += 1) {
      const entry = pendingRightSpacers[spacerIdx];
      if (entry && entry.$row && entry.$spacer) {
        entry.$row.append(entry.$spacer);
      }
    }
  }
}

function stripCharacterBoardSizeClasses($element) {
  if (!$element || !$element.removeClass) {
    return;
  }
  const classAttr = $element.attr('class') || '';
  if (!classAttr) {
    return;
  }
  const classNames = classAttr.split(/\s+/);
  for (let idx = 0; idx < classNames.length; idx += 1) {
    const className = classNames[idx];
    if (className && className.indexOf(CHARACTER_BOARD_SIZE_CLASS_PREFIX) === 0) {
      $element.removeClass(className);
    }
  }
}

function applyCharacterBoardSizeClass($root, $container, sizePreset) {
  stripCharacterBoardSizeClasses($root);
  if ($container && $container.removeClass) {
    stripCharacterBoardSizeClasses($container);
  }
  if (!sizePreset) {
    return;
  }
  const sizeClass = CHARACTER_BOARD_SIZE_CLASS_PREFIX + sizePreset;
  if ($root && $root.addClass) {
    $root.addClass(sizeClass);
  }
  if ($container && $container.addClass) {
    $container.addClass(sizeClass);
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

function resolveRowScaleValue(scale) {
  const numericScale = Number(scale);
  if (Number.isFinite(numericScale) && numericScale > 0) {
    return numericScale;
  }
  return 1;
}

function resolveCharacterTop(defaultPos, totalRows) {
  const baseTopValue = defaultPos ? Number(defaultPos.top) : null;
  const fallbackTop = Number.isFinite(baseTopValue) ? baseTopValue : 0;
  if (!defaultPos || !defaultPos.multiRowTop || !Number.isInteger(totalRows) || totalRows <= 1) {
    return fallbackTop;
  }
  const overrides = defaultPos.multiRowTop;
  const overrideValue = overrides ? overrides[String(totalRows)] : undefined;
  if (Number.isFinite(Number(overrideValue))) {
    return Number(overrideValue);
  }
  return fallbackTop;
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
 * 縦書きテキストをボックス内に追加する。
 * @param {JQuery} $box ボックス要素
 * @param {string} text 表示する文字列
 */
function appendVerticalText($box, text) {
  if (!text) {
    return;
  }
  $('<p>').addClass('cb_text vertical_text').text(text).appendTo($box);
}

/**
 * 横書きテキストをボックス内に追加する。
 * @param {JQuery} $box ボックス要素
 * @param {string} text 表示する文字列
 */
function appendTopText($box, text) {
  if (!text) {
    return;
  }
  $('<p>').addClass('cb_text cb_top_text').text(text).appendTo($box);
}

/**
 * `f.characterBoard` に一覧表示用データを組み立てる。
 * @param {'introduction'|'status'|'winnerFaction'|'openVote'} mode 表示準備モード
 * @param {Object} [options] 将来的な拡張用オプション
 * @returns {{board: CharacterBoard, extras?: Object}|null} 設定したオブジェクトと付随情報
 */
function prepareCharacterBoard(mode, options) {
  const context = createCharacterBoardContext(options);
  if (!context) {
    return null;
  }

  const preparer = CHARACTER_BOARD_PREPARERS[mode];
  if (!preparer) {
    throw new Error('[prepareCharacterBoard] 未対応のモードです: ' + mode);
  }

  const boardData = preparer(context);
  if (!boardData) {
    return null;
  }

  context.f.characterBoard = boardData;
  const result = {
    board: boardData
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
function createCharacterBoardContext(options) {
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
 * `BoardCharacter` を生成するヘルパー。
 * 必須プロパティ以外は既存マクロのデフォルト値（通常立ち絵など）に合わせる。
 * @param {Object} params パラメータ
 * @returns {BoardCharacter}
 */
function createBoardCharacter(params) {
  const fileName = (typeof params.fileName === 'undefined') ? 'normal.png' : params.fileName;
  return new BoardCharacter(
    params.characterId,
    fileName,
    typeof params.bgColor === 'undefined' ? '' : params.bgColor,
    typeof params.topText === 'undefined' ? '' : params.topText,
    typeof params.leftText === 'undefined' ? '' : params.leftText,
    typeof params.reflect === 'undefined' ? false : params.reflect
  );
}

/**
 * `CharacterBoard` を生成するヘルパー。
 * @param {Array<BoardCharacter>} characterList キャラクターリスト
 * @param {{right: number, top: number}} displacement 表示位置調整量
 * @returns {CharacterBoard}
 */
function createCharacterBoard(characterList, displacement, options) {
  const baseOptions = options ? Object.assign({}, options) : {};
  const totalCharacters = Array.isArray(characterList) ? characterList.length : 0;
  const multiRowOptions = resolveCharacterBoardMultiRowOptions(DEFAULT_MULTI_ROW_CONFIG, baseOptions.multiRow);
  if (multiRowOptions) {
    baseOptions.multiRow = multiRowOptions;
  } else {
    delete baseOptions.multiRow;
  }
  const layoutOptions = (baseOptions.layout && typeof baseOptions.layout === 'object') ? baseOptions.layout : null;
  const columnsPerRow = resolveCharacterBoardColumnsPerRow(totalCharacters, baseOptions.multiRow, layoutOptions);
  if (columnsPerRow.length > 0) {
    baseOptions.columnsPerRow = columnsPerRow;
  } else {
    delete baseOptions.columnsPerRow;
  }
  return new CharacterBoard(
    characterList,
    displacement.right,
    displacement.top,
    baseOptions
  );
}

function resolveCharacterBoardOptions(context) {
  const options = (context && context.options) || {};
  const resolvedOptions = {};
  if (typeof options.sizePreset === 'string' && options.sizePreset.length > 0) {
    resolvedOptions.sizePreset = options.sizePreset;
  }
  const layoutOptions = sanitizeCharacterBoardLayoutOptions(options.layout);
  if (layoutOptions) {
    resolvedOptions.layout = layoutOptions;
  }
  const multiRowOptions = resolveCharacterBoardMultiRowOptions(DEFAULT_MULTI_ROW_CONFIG, options.multiRow);
  if (multiRowOptions) {
    resolvedOptions.multiRow = multiRowOptions;
  }
  return resolvedOptions;
}

function resolveCharacterBoardMultiRowOptions(defaultOptions, overrideOptions) {
  const base = sanitizeCharacterBoardMultiRowOptions(defaultOptions);
  const override = sanitizeCharacterBoardMultiRowOptions(overrideOptions);
  if (!base && !override) {
    return null;
  }
  const resolved = {};
  if (base) {
    if (typeof base.maxSingleRowCount === 'number') {
      resolved.maxSingleRowCount = base.maxSingleRowCount;
    }
    if (base.rowOverrides) {
      resolved.rowOverrides = Object.assign({}, base.rowOverrides);
    }
  }
  if (override) {
    if (typeof override.maxSingleRowCount === 'number') {
      resolved.maxSingleRowCount = override.maxSingleRowCount;
    }
    if (override.rowOverrides) {
      const existingOverrides = resolved.rowOverrides || {};
      resolved.rowOverrides = Object.assign({}, existingOverrides, override.rowOverrides);
    }
  }
  return resolved;
}

function sanitizeCharacterBoardMultiRowOptions(multiRow) {
  if (!multiRow || typeof multiRow !== 'object') {
    return null;
  }
  const sanitized = {};
  if (Number.isInteger(multiRow.maxSingleRowCount) && multiRow.maxSingleRowCount > 0) {
    sanitized.maxSingleRowCount = multiRow.maxSingleRowCount;
  }
  const rowOverrides = sanitizeCharacterBoardRowOverrides(multiRow.rowOverrides);
  if (rowOverrides) {
    sanitized.rowOverrides = rowOverrides;
  }
  return Object.keys(sanitized).length > 0 ? sanitized : null;
}

function sanitizeCharacterBoardRowOverrides(rowOverrides) {
  if (!rowOverrides || typeof rowOverrides !== 'object') {
    return null;
  }
  const sanitized = {};
  const keys = Object.keys(rowOverrides);
  for (let idx = 0; idx < keys.length; idx += 1) {
    const key = keys[idx];
    const total = Number(key);
    if (!Number.isInteger(total) || total <= 0) {
      continue;
    }
    const rows = rowOverrides[key];
    if (!Array.isArray(rows) || rows.length === 0) {
      continue;
    }
    const normalized = [];
    let sum = 0;
    let isValid = true;
    for (let rowIdx = 0; rowIdx < rows.length; rowIdx += 1) {
      const value = Number(rows[rowIdx]);
      if (!Number.isInteger(value) || value <= 0) {
        isValid = false;
        break;
      }
      normalized.push(value);
      sum += value;
    }
    if (!isValid || sum !== total) {
      continue;
    }
    sanitized[total] = normalized;
  }
  return Object.keys(sanitized).length > 0 ? sanitized : null;
}

function resolveCharacterBoardColumnsPerRow(totalCharacters, multiRowOptions, layoutOptions) {
  if (!Number.isInteger(totalCharacters) || totalCharacters <= 0) {
    return [];
  }
  const sanitizedOptions = sanitizeCharacterBoardMultiRowOptions(multiRowOptions)
    || sanitizeCharacterBoardMultiRowOptions(DEFAULT_MULTI_ROW_CONFIG)
    || {};
  let maxSingleRowCount = (Number.isInteger(sanitizedOptions.maxSingleRowCount) && sanitizedOptions.maxSingleRowCount > 0)
    ? sanitizedOptions.maxSingleRowCount
    : DEFAULT_MAX_SINGLE_ROW_COUNT;
  const maxColumnsLimit = (layoutOptions && isPositiveIntegerForBoardOptions(layoutOptions.maxColumns))
    ? layoutOptions.maxColumns
    : null;
  if (Number.isInteger(maxColumnsLimit) && maxColumnsLimit > 0) {
    maxSingleRowCount = Math.min(maxSingleRowCount, maxColumnsLimit);
  }
  if (!Number.isInteger(maxSingleRowCount) || maxSingleRowCount <= 0) {
    maxSingleRowCount = 1;
  }
  const overrides = sanitizedOptions.rowOverrides || {};
  const overrideCandidate = overrides[totalCharacters] || overrides[String(totalCharacters)];
  if (Array.isArray(overrideCandidate) && overrideCandidate.length > 0) {
    if (!maxColumnsLimit || overrideCandidate.every(function validateOverride(value) {
      return Number.isInteger(value) && value > 0 && value <= maxColumnsLimit;
    })) {
      return overrideCandidate.slice();
    }
  }
  if (totalCharacters <= maxSingleRowCount) {
    return [totalCharacters];
  }
  const rowsNeeded = Math.ceil(totalCharacters / maxSingleRowCount);
  const baseCount = Math.floor(totalCharacters / rowsNeeded);
  const remainder = totalCharacters % rowsNeeded;
  const result = new Array(rowsNeeded).fill(baseCount);
  for (let idx = 0; idx < remainder; idx += 1) {
    const targetIndex = result.length - 1 - idx;
    result[targetIndex] += 1;
  }
  return result;
}

function sanitizeCharacterBoardLayoutOptions(layout) {
  if (!layout || typeof layout !== 'object') {
    return null;
  }
  const sanitized = {};
  if (isPositiveIntegerForBoardOptions(layout.maxColumns)) {
    sanitized.maxColumns = layout.maxColumns;
  }
  if (isNonNegativeNumberForBoardOptions(layout.columnGap)) {
    sanitized.columnGap = Number(layout.columnGap);
  }
  if (isNonNegativeNumberForBoardOptions(layout.rowGap)) {
    sanitized.rowGap = Number(layout.rowGap);
  }
  if (isFiniteNumberForBoardOptions(layout.rowOffset)) {
    sanitized.rowOffset = Number(layout.rowOffset);
  }
  if (isPositiveNumberForBoardOptions(layout.boxAreaHeight)) {
    sanitized.boxAreaHeight = Number(layout.boxAreaHeight);
  }
  const sanitizedRowScale = normalizeRowScaleOverrides(layout.rowScaleOverrides);
  if (sanitizedRowScale && Object.keys(sanitizedRowScale).length > 0) {
    sanitized.rowScaleOverrides = sanitizedRowScale;
  }
  return Object.keys(sanitized).length > 0 ? sanitized : null;
}

function isPositiveIntegerForBoardOptions(value) {
  return Number.isInteger(value) && value > 0;
}

function isPositiveNumberForBoardOptions(value) {
  return Number.isFinite(Number(value)) && Number(value) > 0;
}

function isNonNegativeNumberForBoardOptions(value) {
  return Number.isFinite(Number(value)) && Number(value) >= 0;
}

function isFiniteNumberForBoardOptions(value) {
  return Number.isFinite(Number(value));
}

function createCharacterBoardLayoutInfo(characterCount, containerWidth, layoutOptions, columnsPerRow, boxBaseHeight, rowScaleOverrides, boxAreaHeight) {
  const columnGap = (layoutOptions && Number.isFinite(layoutOptions.columnGap)) ? Number(layoutOptions.columnGap) : 0;
  const rowGap = (layoutOptions && Number.isFinite(layoutOptions.rowGap)) ? Number(layoutOptions.rowGap) : 0;
  const rowOffset = (layoutOptions && Number.isFinite(layoutOptions.rowOffset)) ? Number(layoutOptions.rowOffset) : 0;
  const normalizedColumnsPerRow = normalizeColumnsPerRow(columnsPerRow, characterCount, layoutOptions);
  const resolvedColumnsPerRow = (normalizedColumnsPerRow.length > 0)
    ? normalizedColumnsPerRow
    : (characterCount > 0 ? [characterCount] : []);
  const rows = resolvedColumnsPerRow.length;
  const maxColumns = rows > 0 ? Math.max.apply(null, resolvedColumnsPerRow) : 0;
  const effectiveColumns = Math.max(1, maxColumns);
  const totalGapWidth = columnGap * (effectiveColumns - 1);
  const effectiveContainerWidth = Math.max(0, containerWidth - totalGapWidth);
  const boxWidth = effectiveColumns > 0 ? (effectiveContainerWidth / effectiveColumns) : 0;
  const halfBoxWidth = boxWidth / 2;
  const baseHeight = Number.isFinite(boxBaseHeight) ? boxBaseHeight : DEFAULT_CHARACTER_BOX_HEIGHT;
  const configAreaHeight = Number.isFinite(boxAreaHeight) ? boxAreaHeight : baseHeight;
  const layoutAreaHeight = (layoutOptions && Number.isFinite(layoutOptions.boxAreaHeight))
    ? Number(layoutOptions.boxAreaHeight)
    : null;
  const totalRowGapHeight = rowGap * Math.max(rows - 1, 0);
  const availableAreaHeight = Math.max(((layoutAreaHeight !== null ? layoutAreaHeight : configAreaHeight) - totalRowGapHeight), 1);
  const boxHeight = rows > 0 ? Math.max(availableAreaHeight / Math.max(rows, 1), 1) : availableAreaHeight;
  const configRowScaleOverrides = normalizeRowScaleOverrides(rowScaleOverrides);
  const layoutRowScaleOverrides = normalizeRowScaleOverrides(layoutOptions && layoutOptions.rowScaleOverrides);
  const mergedRowScaleOverrides = mergeRowScaleOverrides(configRowScaleOverrides, layoutRowScaleOverrides);
  const fallbackRowScale = 1;
  const resolvedRowScale = resolveRowScaleFromOverrides(rows, mergedRowScaleOverrides, fallbackRowScale);
  const safeRowScale = (resolvedRowScale > 0) ? resolvedRowScale : fallbackRowScale;
  const maxScaleByArea = baseHeight > 0 ? (boxHeight / baseHeight) : safeRowScale;
  const normalizedRowScale = Math.min(safeRowScale, maxScaleByArea);
  const boxHeightByRow = rows > 0 ? new Array(rows).fill(boxHeight) : [];
  const rowScaleByRow = rows > 0 ? new Array(rows).fill(normalizedRowScale) : [];
  const rowStartIndices = [];
  const cumulativeCounts = [];
  let runningCount = 0;
  for (let idx = 0; idx < rows; idx += 1) {
    rowStartIndices.push(runningCount);
    runningCount += resolvedColumnsPerRow[idx];
    cumulativeCounts.push(runningCount);
  }
  return {
    characterCount: characterCount,
    columns: effectiveColumns,
    rows: rows,
    columnGap: columnGap,
    rowGap: rowGap,
    rowOffset: rowOffset,
    boxWidth: boxWidth,
    halfBoxWidth: halfBoxWidth,
    boxHeight: boxHeight,
    boxHeightByRow: boxHeightByRow,
    columnsPerRow: resolvedColumnsPerRow,
    rowStartIndices: rowStartIndices,
    cumulativeCounts: cumulativeCounts,
    maxColumns: effectiveColumns,
    baseBoxHeight: baseHeight,
    boxAreaHeight: configAreaHeight,
    rowScale: normalizedRowScale,
    rowScaleByRow: rowScaleByRow
  };
}

function resolveCharacterBoardColumnCount(characterCount, layoutOptions) {
  if (!layoutOptions || !isPositiveIntegerForBoardOptions(layoutOptions.maxColumns)) {
    return characterCount;
  }
  return Math.min(characterCount, layoutOptions.maxColumns);
}

function normalizeColumnsPerRow(columnsPerRow, characterCount, layoutOptions) {
  const normalized = [];
  if (Array.isArray(columnsPerRow) && columnsPerRow.length > 0) {
    let total = 0;
    for (let idx = 0; idx < columnsPerRow.length; idx += 1) {
      const value = Number(columnsPerRow[idx]);
      if (!Number.isInteger(value) || value <= 0) {
        total = null;
        break;
      }
      normalized.push(value);
      total += value;
    }
    if (total !== null) {
      const maxColumnsLimit = (layoutOptions && isPositiveIntegerForBoardOptions(layoutOptions.maxColumns))
        ? layoutOptions.maxColumns
        : null;
      const withinLimit = !maxColumnsLimit || normalized.every(function(value) {
        return value <= maxColumnsLimit;
      });
      if (withinLimit && (!Number.isInteger(characterCount) || characterCount <= 0 || total === characterCount)) {
        return normalized;
      }
    }
  }
  if (!Number.isInteger(characterCount) || characterCount <= 0) {
    return [];
  }
  const columns = resolveCharacterBoardColumnCount(characterCount, layoutOptions);
  if (!Number.isInteger(columns) || columns <= 0) {
    return [];
  }
  const result = [];
  let remaining = characterCount;
  while (remaining > 0) {
    const count = Math.min(columns, remaining);
    result.push(count);
    remaining -= count;
  }
  return result;
}

function normalizeRowScaleOverrides(rowScaleOverrides) {
  if (!rowScaleOverrides || typeof rowScaleOverrides !== 'object') {
    return {};
  }
  const normalized = {};
  Object.keys(rowScaleOverrides).forEach(function(key) {
    const rowCount = Number(key);
    const scaleValue = Number(rowScaleOverrides[key]);
    if (Number.isInteger(rowCount) && rowCount > 0 && Number.isFinite(scaleValue) && scaleValue > 0) {
      normalized[rowCount] = scaleValue;
    }
  });
  return normalized;
}

function mergeRowScaleOverrides(baseOverrides, overridingOverrides) {
  const merged = Object.assign({}, baseOverrides || {});
  if (overridingOverrides) {
    Object.keys(overridingOverrides).forEach(function(key) {
      merged[key] = overridingOverrides[key];
    });
  }
  return merged;
}

function resolveRowScaleFromOverrides(rowCount, overrides, fallback) {
  if (rowCount > 0 && overrides && Object.prototype.hasOwnProperty.call(overrides, rowCount)) {
    return Number(overrides[rowCount]);
  }
  return fallback;
}

function getCharacterBoardItemLayout(layoutInfo, index) {
  if (!layoutInfo) {
    return {
      columnIndex: 0,
      rowIndex: 0,
      boxLeft: 0,
      rowTopOffset: 0
    };
  }
  const columnsPerRow = Array.isArray(layoutInfo.columnsPerRow) ? layoutInfo.columnsPerRow : null;
  const rowStartIndices = Array.isArray(layoutInfo.rowStartIndices) ? layoutInfo.rowStartIndices : null;
  if (!columnsPerRow || columnsPerRow.length === 0 || !rowStartIndices || rowStartIndices.length === 0) {
    const columns = layoutInfo.columns || 0;
    if (!columns) {
      return {
        columnIndex: 0,
        rowIndex: 0,
        boxLeft: 0,
        rowTopOffset: layoutInfo.rowOffset || 0
      };
    }
    const fallbackColumnIndex = index % columns;
    const fallbackRowIndex = Math.floor(index / columns);
    const fallbackBoxLeft = (layoutInfo.boxWidth + layoutInfo.columnGap) * fallbackColumnIndex;
    const fallbackRowTopOffset = (layoutInfo.rowOffset || 0) + (layoutInfo.rowGap * fallbackRowIndex);
    return {
      columnIndex: fallbackColumnIndex,
      rowIndex: fallbackRowIndex,
      boxLeft: fallbackBoxLeft,
      rowTopOffset: fallbackRowTopOffset
    };
  }
  let resolvedRowIndex = 0;
  for (let idx = rowStartIndices.length - 1; idx >= 0; idx -= 1) {
    if (index >= rowStartIndices[idx]) {
      resolvedRowIndex = idx;
      break;
    }
  }
  if (resolvedRowIndex >= columnsPerRow.length) {
    resolvedRowIndex = columnsPerRow.length - 1;
  }
  const rowStart = rowStartIndices[resolvedRowIndex] || 0;
  const rowSize = columnsPerRow[resolvedRowIndex] || 1;
  let columnIndex = index - rowStart;
  if (columnIndex < 0) {
    columnIndex = 0;
  } else if (columnIndex >= rowSize) {
    columnIndex = rowSize - 1;
  }
  const boxLeft = (layoutInfo.boxWidth + layoutInfo.columnGap) * columnIndex;
  const rowTopOffset = (layoutInfo.rowOffset || 0) + (layoutInfo.rowGap * resolvedRowIndex);
  return {
    columnIndex: columnIndex,
    rowIndex: resolvedRowIndex,
    boxLeft: boxLeft,
    rowTopOffset: rowTopOffset
  };
}

function getRowScaleForRow(layoutInfo, rowIndex) {
  if (!layoutInfo) {
    return 1;
  }
  if (Array.isArray(layoutInfo.rowScaleByRow) && Number.isFinite(layoutInfo.rowScaleByRow[rowIndex])) {
    return layoutInfo.rowScaleByRow[rowIndex];
  }
  if (Number.isFinite(layoutInfo.rowScale)) {
    return layoutInfo.rowScale;
  }
  return 1;
}

function createCharacterBoardSpacer(width, height) {
  const numericWidth = Number(width);
  const resolvedWidth = (Number.isFinite(numericWidth) && numericWidth > 0) ? numericWidth : 0;
  const numericHeight = Number(height);
  const resolvedHeight = (Number.isFinite(numericHeight) && numericHeight > 0) ? numericHeight : null;
  const css = {
    width: resolvedWidth + 'px'
  };
  if (resolvedHeight !== null) {
    css.height = resolvedHeight + 'px';
    css['--cb-box-height'] = resolvedHeight + 'px';
  }
  return $('<div>').addClass('cb_box cb_box--spacer').attr({
    'aria-hidden': 'true'
  }).css(css);
}


/**
 * Prepare character board data per mode.
 */
const CHARACTER_BOARD_PREPARERS = {
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

      characterList.push(createBoardCharacter({
        characterId: characterId,
        fileName: 'normal.png',
        bgColor: bgColor,
        leftText: characterObject.name || '',
        reflect: reflect
      }));
    }

    return createCharacterBoard(characterList, DEFAULT_BOARD_OFFSET, resolveCharacterBoardOptions(context));
  },
  status: function prepareStatusCharacters(context) {
    const f = context.f || {};
    const mp = context.mp || {};
    const characterObjects = f.characterObjects || {};
    const statusFace = f.statusFace || {};
    const participantsIdList = Array.isArray(f.participantsIdList) ? f.participantsIdList : [];
    const characterList = [];
    const winnerFaction = mp.winnerFaction;
    const isDrawByRevote = winnerFaction === DRAW_BY_REVOTE_FACTION;

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
      } else if (winnerFaction === DRAW_BY_REVOTE_FACTION) {
        fileName = statusFaceEntry.draw || fileName;
      } else if (characterObject.role && characterObject.role.faction === winnerFaction) {
        fileName = (statusFaceEntry.win && statusFaceEntry.win[winnerFaction]) || fileName;
      } else {
        fileName = statusFaceEntry.lose || fileName;
      }

      characterList.push(createBoardCharacter({
        characterId: characterId,
        fileName: fileName,
        bgColor: bgColor,
        leftText: characterObject.name || '',
        reflect: (typeof getReflectFromCharacterId === 'function')
          ? getReflectFromCharacterId(characterId)
          : false
      }));
    }

    return createCharacterBoard(characterList, DEFAULT_BOARD_OFFSET, resolveCharacterBoardOptions(context));
  },
  winnerFaction: function prepareWinnerFactionCharacters(context) {
    const f = context.f || {};
    const mp = context.mp || {};
    const characterObjects = f.characterObjects || {};
    const statusFace = f.statusFace || {};
    const participantsIdList = Array.isArray(f.participantsIdList) ? f.participantsIdList : [];
    const characterList = [];
    const winnerFaction = mp.winnerFaction;
    const isDrawByRevote = winnerFaction === DRAW_BY_REVOTE_FACTION;

    for (let idx = 0; idx < participantsIdList.length; idx += 1) {
      const characterId = participantsIdList[idx];
      if (!characterId) {
        continue;
      }
      const characterObject = characterObjects[characterId] || {};
      const statusFaceEntry = statusFace[characterId] || {};

      let fileName = '';
      if (isDrawByRevote) {
        fileName = statusFaceEntry.draw || '';
      } else if (characterObject.role && characterObject.role.faction === winnerFaction) {
        fileName = (statusFaceEntry.win && statusFaceEntry.win[winnerFaction]) || '';
      } else {
        continue;
      }

      characterList.push(createBoardCharacter({
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

    return createCharacterBoard(characterList, DEFAULT_BOARD_OFFSET, resolveCharacterBoardOptions(context));
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

      characterList.push(createBoardCharacter({
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

    return createCharacterBoard(characterList, DEFAULT_BOARD_OFFSET, resolveCharacterBoardOptions(context));
  }
};

window.renderCharacterBoard = renderCharacterBoard;
window.prepareCharacterBoard = prepareCharacterBoard;


