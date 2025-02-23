<template>
<footer>
    <div class="footer-top">
        <div class="footer-logo">
            <img src="/images/logo_Ibetan.png" alt="logo" class="logo" />
        </div>
        <div class="footer-content">
            <ul class="footer-nav">
                <li><a href="/">Top</a></li>                
                <li><a href="/ChatRoom">ホーム</a></li>
                <li><a href="/policy">プライバシーポリシー</a></li>
                <li><a href="/UserMyPage">お問い合わせ</a></li>
            </ul>
            <div class="social-media">
                <a href="https://twitter.com" target="_blank" aria-label="X (旧Twitter)"><i class="fab fa-x-twitter"></i></a>
                <a href="https://facebook.com" target="_blank" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                <a href="https://instagram.com" target="_blank" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </div>
</footer>
</template>  

<style>
footer {
    background-color: #333;
    color: #fff;
    padding: 5px 0;
    display: flex;
    flex-direction: column; /* 縦方向に並べる */
}

.footer-top {
    display: flex;
    justify-content: flex-start; /* ロゴを左に配置 */
    align-items: flex-start; /* ロゴの位置を上に揃える */
    width: 100%; /* 画面幅いっぱいに広げる */
}

.footer-logo {
    display: flex;
    align-items: center;
    margin-left: 10px; /* ロゴを少し左からずらす */
    margin-right: 20px; /* ロゴとリンクの間隔 */
}

.footer-logo .logo {
    max-height: 80px; /* ロゴの縦幅を指定 */
    width: auto;
}

.footer-content {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin-left: 20px; /* ロゴの右側に少し余白 */
}

.footer-nav {
    list-style: none;
    padding: 0;
    display: flex;
    justify-content: center; /* 横幅に合わせて中央揃え */
    margin: 10px 0 0 0; /* 上に少し余白を追加 */
    width: 100%;
}

.footer-nav li {
    margin: 0 20px; /* リストアイテム間の間隔 */
}

.footer-nav li a {
    color: #fff;
    text-decoration: none;
    font-size: 1em; /* 文字サイズを1emに設定 */
    line-height: 1.2; /* 行間を調整 */
    display: block;
}

.social-media {
    display: flex;
    justify-content: center;
    margin-top: 10px;
}

.social-media a {
    margin: 0 10px;
    color: #fff;
    font-size: 1.5em;
}
</style>
